# NewRelicSandbox.Umbrella

This example consists of a barebone Phoenix + Ecto application that uses `NewRelic`,
`NewRelicPhoenix` and `NewRelicAddons` for monitoring following transactions:

- web transactions originating in Phoenix endpoint (`NewRelicSandboxWeb.Endpoint`)
- background process transactions originating in custom genserver
  (`NewRelicSandbox.Accounts.OldUserPeriodicDeletion`)

...and for monitoring following operations within both of the above:

- database operations on Ecto repo (`NewRelicSandbox.Repo`)
- calls to Phoenix context entry module (`NewRelicSandbox.Accounts`)

## Usage

Run the application:

```bash
cp config/dev.secret.example.exs config/dev.secret.exs
vim config/dev.secret.exs # configure license_key
mix deps.get
mix phx.server
open http://localhost:4000/users # play with the resource
```

Then visit https://rpm.newrelic.com, pick the application and check out each of the sections:

- Transactions
- Distributed Tracing
- Databases
- BEAM
