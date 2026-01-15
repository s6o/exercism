defmodule S6o.ProviderConfig do
  @moduledoc """
  Capture a Payment Provider configuration.
  Fields:
    * `currency` - the currency code accepted by the Payment Provider
    * `delay_range` - the processing delay range in milliseconds
    * `dist` - the success distribution accordingly to success_rate
    * `threshold_amount` - 0 (zero) for no threshold, otherwise a threshold
      amount in respective currency's base units
    * `threshold_check` - threshold check/comparison function, is allowed to be
      one of the following: `</2`, `<=/2`, `==/2`, `>=/2`, `>/2` from the Kernel
      module
  """
  @type currency_code_t :: String.t()
  @type delay_range_t :: %{min: pos_integer(), max: pos_integer()}
  @type threshold_amount_t :: non_neg_integer()
  @type threshold_check_t :: (amount :: pos_integer(), limit :: pos_integer() -> boolean())
  @type t :: %__MODULE__{
          currency: currency_code_t(),
          delay_range: delay_range_t(),
          dist: list(boolean()),
          threshold_amount: threshold_amount_t(),
          threshold_check: threshold_check_t()
        }
  defstruct [
    :currency,
    :delay_range,
    :dist,
    :threshold_amount,
    :threshold_check
  ]

  @doc """
  Construct a new Provider configuration if specified input arguments are valid.
  Upon invalid input arguments the `ArgumentError` is raised, with respective
  error message containing one or several snake_cased failure codes.

  The `delay_range`'s `min` can be between 0-4999 and `max` can be between `min`+1-5000.
  The `success_rate` must be between 0-100. Yes, that is correct, for testing,
  configuration with 0 (zero) success rate are allowed.
  The minimal value for `threshold_amount` is 0 (zero), meaning no threshold amount set.
  The `threshold_check` has to be one of the comparison functions from the Kernel module.
  """
  @spec new!(
          currency_code :: currency_code_t(),
          delay_range :: delay_range_t(),
          success_rate :: pos_integer()
        ) ::
          S6o.ProviderConfig.t()
  @spec new!(
          currency_code :: currency_code_t(),
          delay_range :: delay_range_t(),
          success_rate :: pos_integer(),
          threshold_amount :: threshold_amount_t()
        ) ::
          S6o.ProviderConfig.t()
  @spec new!(
          currency_code :: currency_code_t(),
          delay_range :: delay_range_t(),
          success_rate :: pos_integer(),
          threshold_amount :: threshold_amount_t(),
          threshold_check :: threshold_check_t()
        ) ::
          S6o.ProviderConfig.t()
  def new!(
        currency_code,
        delay_range,
        success_rate,
        threshold_amount \\ 0,
        threshold_check \\ &Kernel.>/2
      ) do
    failures =
      [
        if(not is_binary(currency_code), do: :currency_code_invalid),
        check_currency_code_length(currency_code),
        if(not is_map(delay_range), do: :delay_range_not_map),
        check_delay_range_member_limits(delay_range),
        if(not is_integer(success_rate), do: :success_rate_invalid),
        check_success_rate_range(success_rate),
        if(not is_integer(threshold_amount), do: :threshold_amount_invalid),
        if(is_integer(threshold_amount) and threshold_amount < 0,
          do: :threshold_amount_out_of_range
        ),
        if(not is_function(threshold_check, 2), do: :threshold_check_invalid),
        check_threshold_function(threshold_check)
      ]
      |> Enum.filter(fn e -> not is_nil(e) end)

    if Enum.empty?(failures) do
      %__MODULE__{
        currency: String.upcase(currency_code),
        delay_range: delay_range,
        dist:
          1..100
          |> Enum.map(fn i -> if(i <= success_rate, do: true, else: false) end)
          |> Enum.shuffle(),
        threshold_amount: threshold_amount,
        threshold_check: threshold_check
      }
    else
      raise(ArgumentError, Enum.map(failures, &Atom.to_string/1) |> Enum.join(", "))
    end
  end

  @doc """
  Extract payment provider module atom from payment request.
  """
  @spec payment_provider(payment_request :: S6o.PaymentRequest.t()) ::
          {:error, :unknown_payment_provider} | {:ok, S6o.ProviderModule.t()}
  def payment_provider(%S6o.PaymentRequest{provider: provider_module_str})
      when is_binary(provider_module_str) do
    provider_module = String.to_atom(provider_module_str)

    case Kernel.function_exported?(provider_module, :process, 1) do
      false -> {:error, :unknown_payment_provider}
      true -> {:ok, provider_module}
    end
  end

  def payment_provider(_), do: {:error, :unknown_payment_provider}

  @doc """
  Simulate payment Provider processing accordingly to the provider's configuration.

  The simulation will verify the payment request's provider module configuration,
  set via routing into the `:provider` field, against the respective provider
  module instance calling this `process/2`.

  This will help to catch routing and payment provider module configuration errors
  e.g. avoid cases where `S6o.PaymentRequest` in a currency is routed to a payment
  provider with a different currency.
  """
  @spec process(
          payment_request :: S6o.PaymentRequest.t(),
          provider_impl :: S6o.ProviderModule.t()
        ) ::
          {:error,
           :payment_request_missing_provider
           | :payment_request_provider_mismatch
           | :provider_network_failure
           | :provider_currency_mismatch
           | :provider_threshold_amount_mismatch
           | :provider_threshold_check_mismatch}
          | {:ok, S6o.PaymentReceipt.t()}
  def process(%S6o.PaymentRequest{provider: routed_provider} = pr, provider_impl)
      when is_binary(routed_provider) and is_atom(provider_impl) do
    provider_module = String.to_atom(routed_provider)

    if Kernel.function_exported?(provider_module, :process, 1) do
      try do
        %__MODULE__{
          currency: cc,
          delay_range: delay,
          dist: dist,
          threshold_amount: ta,
          threshold_check: tc
        } = provider_module.config()

        config_failures =
          [
            if(cc != provider_impl.config().currency, do: :provider_currency_mismatch),
            if(ta != provider_impl.config().threshold_amount,
              do: :provider_threshold_amount_mismatch
            ),
            if(tc != provider_impl.config().threshold_check,
              do: :provider_threshold_check_mismatch
            )
          ]
          |> Enum.filter(fn e -> not is_nil(e) end)

        if Enum.empty?(config_failures) do
          sleep_time = Enum.random(delay.min..delay.max)
          :timer.sleep(sleep_time)

          if Enum.at(dist, Enum.random(0..99)) do
            if Enum.at(dist, Enum.random(0..99)) do
              {:ok, S6o.PaymentReceipt.new!(pr, :success)}
            else
              {:ok, S6o.PaymentReceipt.new!(pr, :failure)}
            end
          else
            {:error, :provider_network_failure}
          end
        else
          {:error, Enum.at(config_failures, 0)}
        end
      rescue
        _ ->
          {:error, :payment_request_provider_mismatch}
      end
    else
      {:error, :payment_request_missing_provider}
    end
  end

  def process({:error, _} = e, _), do: e
  def process(_, _), do: {:error, :invalid_process_arguments}

  defp check_currency_code_length(currency_code) do
    if is_binary(currency_code) and String.length(currency_code) != 3 do
      :currency_code_length
    end
  end

  defp check_delay_range_member_limits(delay_range) do
    if is_map(delay_range) do
      try do
        %{min: min, max: max} = delay_range

        if min >= 0 and max <= 5000 do
          if min < max do
            nil
          else
            :delay_max_less_than_min
          end
        else
          :delay_out_of_range
        end
      rescue
        _ ->
          :delay_range_missing_min_max
      end
    end
  end

  defp check_success_rate_range(success_rate) do
    if is_integer(success_rate) do
      if success_rate >= 0 and success_rate <= 100 do
        nil
      else
        :success_rate_out_of_range
      end
    end
  end

  defp check_threshold_function(threshold_check) do
    if is_function(threshold_check, 2) do
      valid =
        Enum.member?(
          [
            &Kernel.</2,
            &Kernel.<=/2,
            &Kernel.==/2,
            &Kernel.>=/2,
            &Kernel.>/2
          ],
          threshold_check
        )

      if valid do
        nil
      else
        :threshold_check_function_invalid
      end
    end
  end
end
