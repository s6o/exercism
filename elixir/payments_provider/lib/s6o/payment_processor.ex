defmodule S6o.PaymentProcessor do
  @moduledoc """
  Payment processing operations with required state as struct.
  """
  @type t :: %__MODULE__{
          route_table: S6o.ProviderRouting.routes_t(),
          logger: S6o.PaymentLogger.t(),
          retry_max: pos_integer()
        }
  defstruct [
    :route_table,
    :logger,
    :retry_max
  ]

  @doc """
  Initialise new payment processor state.
  """
  @spec new!(
          route_table :: S6o.ProviderRouting.routes_t(),
          logger :: module(),
          retry_max :: pos_integer()
        ) :: S6o.PaymentProcessor.t()
  def new!(route_table, logger, retry_max) when retry_max > 0 do
    %__MODULE__{
      route_table: route_table,
      logger: logger,
      retry_max: retry_max
    }
  end

  @doc """
  Process sepcified payment, given current payment processor state.
  Log the payment processing attempt via configured logger in the state.
  Returns a tuple of updated payment request and payment processing result.

  Each payment processing attempt is captured in the payment request's metadata,
  depending on the `retry_max` value. Total captured attempts can be `retry_max + 1`.

  The attempts are captured in payment request's metadata under the `:attempts`
  key, which contains a list, where the latest attempt is the first element of
  the list.
  """
  @spec process_payment(payment_request :: S6o.PaymentRequest.t(), state :: t()) ::
          {new_payment_request :: S6o.PaymentRequest.t(),
           result :: {:error, any()} | {:ok, S6o.PaymentReceipt.t()}}
  def process_payment(%S6o.PaymentRequest{} = pr, %__MODULE__{} = state) do
    current_retries = Map.get(pr.metadata, :attempts, [])

    if state.retry_max > 0 and Enum.count(current_retries) > state.retry_max do
      {pr, Enum.at(current_retries, 0)}
    else
      case S6o.ProviderRouting.route_payment(pr, state.route_table) do
        {:error, _} = e ->
          new_pr = add_payment_result_to_attempts(pr, e)
          state.logger.log(new_pr)
          {new_pr, e}

        {:ok, %S6o.PaymentRequest{} = pay_req_routed} ->
          case S6o.ProviderConfig.payment_provider(pay_req_routed) do
            {:error, _} = e ->
              new_pr = add_payment_result_to_attempts(pay_req_routed, e)
              state.logger.log(new_pr)
              {new_pr, e}

            {:ok, provider_module} ->
              case provider_module.process(pay_req_routed) do
                {:error, _} = e ->
                  new_pr = add_payment_result_to_attempts(pay_req_routed, e)
                  state.logger.log(new_pr)
                  {new_pr, e}

                {:ok, receipt} = r ->
                  new_pr = add_payment_result_to_attempts(pay_req_routed, receipt)
                  state.logger.log(new_pr)
                  {new_pr, r}
              end
          end
      end
    end
  end

  @doc """
  Retry payment processing accordingly to `process_payment/2` result and `retry_max`.
  Does nothing when `process_payment/2` result does not require retry.
  """
  @spec retry_payment(
          {payment_request :: S6o.PaymentRequest.t(),
           result :: {:error, any()} | {:ok, S6o.PaymentReceipt.t()}},
          state :: t()
        ) ::
          {new_payment_request :: S6o.PaymentRequest.t(),
           result :: {:error, any()} | {:ok, S6o.PaymentReceipt.t()}}
  def retry_payment({%S6o.PaymentRequest{} = pr, {:error, _} = r}, %__MODULE__{} = s) do
    retry_payment(pr, r, s)
  end

  def retry_payment(
        {%S6o.PaymentRequest{} = pr, {:ok, %S6o.PaymentReceipt{status: :failure}} = r},
        %__MODULE__{} = s
      ) do
    retry_payment(pr, r, s)
  end

  def retry_payment({%S6o.PaymentRequest{}, _} = result, %__MODULE__{}) do
    result
  end

  @spec retry_payment(
          payment_request :: S6o.PaymentRequest.t(),
          result :: {:error, any()} | {:ok, S6o.PaymentReceipt.t()},
          state :: t()
        ) ::
          {new_payment_request :: S6o.PaymentRequest.t(),
           result :: {:error, any()} | {:ok, S6o.PaymentReceipt.t()}}
  defp retry_payment(%S6o.PaymentRequest{} = pr, result, %__MODULE__{} = state) do
    1..state.retry_max
    |> Enum.reduce_while({pr, result}, fn _elem, {cpr, _} ->
      case S6o.PaymentProcessor.process_payment(cpr, state) do
        {_, {:error, _}} = r -> {:cont, r}
        {_, {:ok, %S6o.PaymentReceipt{status: :success}}} = r -> {:halt, r}
        {_, _} = r -> {:cont, r}
      end
    end)
  end

  @spec add_payment_result_to_attempts(S6o.PaymentRequest.t(), term()) :: S6o.PaymentRequest.t()
  defp add_payment_result_to_attempts(%S6o.PaymentRequest{} = pr, result) do
    current_attempts = Map.get(pr.metadata, :attempts, [])

    new_metadata =
      Map.put(pr.metadata, :attempts, [result | current_attempts])

    Map.put(pr, :metadata, new_metadata)
  end
end
