defmodule HttpServerTest do
  use ExUnit.Case

  alias Servy.HttpServer
  alias Servy.HttpClient

  test "accepts a request on a socket and sends back a response" do
    pid = spawn(HttpServer, :start, [4000])

    urls = [
      "http://localhost:4000/wildthings",
      "http://localhost:4000/bears",
      "http://localhost:4000/bears/1",
      "http://localhost:4000/wildlife",
      "http://localhost:4000/api/bears"
    ]

    urls
    |> Enum.map(&Task.async(fn -> HTTPoison.get(&1) end))
    |> Enum.map(&Task.await/1)
    |> Enum.map(&assert_successful_response/1)


    url = "http://localhost:4000/wildthings"
    max_concurrent_requests = 5

    # ### Task

    1..max_concurrent_requests
    |> Enum.map(fn(_) -> Task.async(fn -> HTTPoison.get(url) end) end)
    |> Enum.map(&Task.await/1)
    |> Enum.map(fn {:ok, response} ->
      assert response.status_code == 200
      assert response.body == "Bears, Lions, Tigers"
    end)

    ### Process

    # parent = self()
    # # Spawn the client processes
    # for _ <- 1..max_concurrent_requests do
    #     spawn(fn ->
    #     # Send the request
    #     {:ok, response} = HTTPoison.get url

    #     # Send the response back to the parent
    #     send(parent, {:ok, response})
    #   end)
    # end

    # # Await all {:handled, response} messages from spawned processes.
    # for _ <- 1..max_concurrent_requests do
    #   receive do
    #     {:ok, response} ->
    #       assert response.status_code == 200
    #       assert response.body == "Bears, Lions, Tigers"
    #   end
    # end

    ### Sequential

    # {:ok, response} = HTTPoison.get "http://localhost:4000/wildthings"
    # assert response.status_code == 200
    # assert response.body == "Bears, Lions, Tigers"

    # request = """
    # GET /wildthings HTTP/1.1\r
    # Host: example.com\r
    # User-Agent: ExampleBrowser/1.0\r
    # Accept: */*\r
    # \r
    # """

    # response = HttpClient.send_request(request)

    # assert response == """
    # HTTP/1.1 200 OK\r
    # Content-Type: text/html\r
    # Content-Length: 20\r
    # \r
    # Bears, Lions, Tigers
    # """

    Process.exit(pid, :kill)
  end

  defp assert_successful_response({:ok, response}) do
    assert response.status_code == 200
  end
end
