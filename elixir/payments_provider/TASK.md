# Payments Provider Challenge

Copied at 2025-05-09 09:00:00 from [Yolo's Payment Provider Challenge](https://coingaming.github.io/payments-provider-challenge/)

This challenge aims to evaluate your ability to structure an elixir application,
handle concurrency and common logic in payment’s providers.

## Intro

Build a Payment Router in Elixir that receives payment requests and dispatches
them to the appropriate provider with retry logic, logging, and provider routing
for fiat payments. Your system should handle both fiat and crypto payments.

When a new payment request comes in, your system should:

1. Determine which provider to use based on the currency and optional metadata.
2. Call that provider to process the payment.
3. Retry on failure.
4. Log all attempts.

## Requirements

### 1. PaymentRequest Struct

Define a struct with the following fields:

```elixir
%PaymentRequest{
  id: UUID,
  amount: integer,           # In cents for fiat or in satoshis for BTC
  currency: String.t(),      # "EUR", "BTC"
  metadata: map(),
  provider: String.t()
}
```

### 2. PaymentProcessor Module

Implement `PaymentProcessor.process_payment/1`:

* Accepts a PaymentRequest.
* Selects an appropriate provider (see routing below).
* Sends the payment to the provider.
* Retries up to 2 times on failure (3 total attempts).
* Returns {:ok, receipt} or {:error, reason}.

### 3. Providers

This challenge does not require real integrations or HTTP calls.

All providers should be implemented as pure Elixir modules that simulate behavior:

* Sleeping for a random amount of time (`:timer.sleep/1`)
* Returning success or failure randomly (70–80% success rate)

Each provider should implement a `process/1` function that accepts a
`PaymentRequest` and returns one of:

```elixir
{:ok, receipt}
{:error, reason}
```

#### Receipt Format

The receipt can be a map or struct and should include:

```elixir
%{
  id: payment_id,
  provider: "ProviderName",
  status: :success,
  timestamp: DateTime.t()
}
```

You may extend the structure with additional fields such as metadata or any internal field info.

#### Provider Routing

* CryptoProvider
  * Accepts "BTC" payments.
  * Simulate:
    * 70% success rate
    * Random delay (100–500 ms)

* FiatProviderA / FiatProviderB
  * Both accept "EUR" payments.
  * Your router must decide which to use based on amount:
    * If amount < 10_000, use FiatProviderA
    * If amount >= 10_000, use FiatProviderB
  * Simulate:
    * 80% success rate
    * Random delay (300–700 ms)

### 4. Logging

Store in memory (ETS, Agent, etc) the logs of each attempt.

Each log entry should include:

* `payment_id`
* `provider`
* attempt number
* success or failure
* timestamp

## Optional Features

These are not required but can earn bonus points:

* Timeout logic (abort if a provider takes more than 1 second).
* Simple stats module (total attempts, success rate per provider).

## Constraints

* No database usage
* No Phoenix required
* No libraries are required, unless for static code checking or the Decimal library.
* Tests are required

## How We Evaluate

* Code organization and clarity
* Elixir fundamentals
* OTP usage if applicable
* Error handling and retry logic
* Simplicity and maintainability

## Submission

We ask you to not publish the solution publicly, please send us a ZIP archive or
add us into your private repository.
