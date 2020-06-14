# Servy

App to Developing with Elixir/OTP course (The Pragmatic Studio)

## Run the server:

```
mix run -e "Servy.ServicesSupervisor.start_link(:ok); Servy.HttpServer.start(4000)"
```
