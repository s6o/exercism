# Payments Provider Challenge

My solution to the Payments Provider Challenge is organized as an
[`Application`](https://hexdocs.pm/elixir/1.17.3/Application.html),
which starts a [Supervisor](https://hexdocs.pm/elixir/1.17.3/Supervisor.html) with
2 [GenServer](https://hexdocs.pm/elixir/1.17.3/GenServer.html) based BEAM
processes for processing payment requests and for logging the processing attempts:

* [S6o.Actors.PaymentLogging](./lib/s6o/actors/payment_logging.ex)
* [S6o.Actors.PaymentProcessing](./lib/s6o/actors/payment_logging.ex)

The GenServer `S6o.Actors.PaymentProcessing` drives the payment processing logic.
Upon initialisation it will create the payment processor state acordingly to the
passed in configuration and will start waiting for the payment request from clients.

The [payment processor state](./lib/s6o/payment_processor.ex) consits of a payment
provider [routing table](./lib/s6o/provider_routing.ex), [logger module (behaviour)](./lib/s6o/payment_logger.ex)
and maximum retry value: `retry_max`.

The GenServer `S6o.Actors.PaymentLogging` is the default [S6o.PaymentLogger behaviour](./lib/s6o/payment_logger.ex)
implementation for `S6o.Actors.PaymentLogging`. Each payment request and its
processing attempt is captured by the logger in the [payment request's metadata](./lib/s6o/payment_request.ex),
under the `:attempts` map key. Other examples of `S6o.PaymentLogger` implementations
(`S6o.LoggerDevNull`, `S6o.LoggerAgent`) can be seen in the [payment processor tests](./test/s6o/payment_processor_test.exs).

## Creating Payment Providers

Each payment processing provider is expected to be a module implementing the
[ProviderModule](./lib/s6o/provider_module.ex) behaviour. The (new) provider
module must implement 2 callbacks: `config/0` and `process/1`.

The `config/0` is required to return an instance of the [provider configuration](./lib/s6o/provider_config.ex)
and the `process/1` implementation is similar for all provider modules: calling
the `S6o.ProviderConfig.process/2` with the [payment request](./lib/s6o/payment_request.ex)
and the implementing module itself.

Implementing the `S6o.ProviderModule.process/1` via `S6o.ProviderConfig.process/2`
with the implementing module passed as an argument, allows to validate the implementing
provider's module configuration against the [payment provider routing table](./lib/s6o/provider_routing.ex).
For example, payment provider routing table currency mis-configurations are detected
upon routing.

Accordingly to the task, following payment providers are implemented:

* [S6o.Providers.ProvicerBtc](./lib/s6o/providers/provider_btc.ex)
* [S6o.Providers.ProvicerEurSmall](./lib/s6o/providers/provider_eur_small.ex)
* [S6o.Providers.ProvicerEur](./lib/s6o/providers/provider_eur.ex)

An example of a new payment provider module implementation for USD payments,
with a simulated delay between 100 and 400 milliseconds, with a 85 percent success rate:

```elixir
defmodule S6o.Providers.ProviderUsd do
  @moduledoc false
  @behaviour S6o.ProviderModule

  @impl S6o.ProviderModule
  @spec config() :: S6o.ProviderConfig.t()
  def config() do
    S6o.ProviderConfig.new!("USD", %{min: 100, max: 400}, 85)
  end

  @impl S6o.ProviderModule
  @spec process(payment_request :: S6o.PaymentRequest.t()) ::
          {:error,
           :invalid_process_payment_request
           | :payment_request_missing_provider
           | :payment_request_provider_mismatch
           | :provider_currency_mismatch
           | :provider_network_failure
           | :provider_threshold_amount_mismatch
           | :provider_threshold_check_mismatch}
          | {:ok, S6o.PaymentReceipt.t()}
  def process(%S6o.PaymentRequest{} = s), do: S6o.ProviderConfig.process(s, __MODULE__)

  def process(_), do: {:error, :invalid_process_payment_request}
end
```

## Configuring the Payment Provider routing

The payment provider routing is done based on a [routing table](./lib/s6o/provider_routing.ex),
which is an [Elixir Map](https://hexdocs.pm/elixir/1.17.3/Map.html), where routing rules
are the map keys and values are specific modules implementing the `S6o.ProviderModule`
behaviour.

Each routing rule (i.e. map key aka `route_key_t`), is a 3 element tuple of:

* currency code
* threshold amount
* threshold check function

The default routing table, capturing the task requirements, is implemented in
[`S6o.ProviderRouting.route_table!/1`](./lib/s6o/provider_routing.ex).

The routing logic accordingly to the specified route table is implemented in
[`S6o.ProviderRouting.route_payment!/2`](./lib/s6o/provider_routing.ex).

## Creating Payment Requests

The create instances of [`S6o.PaymentRequest`s](./lib/s6o/payment_request.ex)
with supported currencies the following helper functions should be used:

* `S6o.PaymentRequest.btc!/1`
* `S6o.PaymentRequest.eur!!/1`
* `S6o.PaymentRequest.usd!/1`

The `S6o.PaymentRequest.usd!/1` is currently meant for testing of invalid routing
configurations as no (default) provider module implementation for USD exists and
was not required by the task specification.

## Processing Payments

To test payment request processing in IEX execute following in the project
directory:

```sh
iex -S mix
```

Then in IEX to create payment requests and to simulate payment processing:

```iex
1..5
|> Enum.map(fn i -> S6o.PaymentRequest.btc!(i * 1000) end)
|> Enum.map(&S6o.Actors.PaymentProcessing.process_payment/1)
```

or for EUR payment requests:

```iex
1..6
|> Enum.map(fn i -> S6o.PaymentRequest.eur!(i * 3000) end)
|> Enum.map(&S6o.Actors.PaymentProcessing.process_payment/1)
```

For quering the log use:

```iex
S6o.Actors.PaymentLogging.entries()
```

## Statistics

Payment provider [statistics](./lib/s6o/stats.ex) can be queried over the payment
log entries.

After processing a set of payment requests:

```iex
1..10
|> Enum.map(fn i -> S6o.PaymentRequest.eur!(i * 1700) end)
|> Enum.map(&S6o.Actors.PaymentProcessing.process_payment/1)
```

The per provider statistics can be retrived via:

```iex
S6o.Actors.PaymentLogging.entries() |> S6o.Stats.provider_stats()
```
