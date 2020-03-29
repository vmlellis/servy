defmodule Servy.Parser do

  alias Servy.Conv

  def parse(request) do
    [top, params_string] = request |> String.split("\n\n")

    [request_line | header_lines] = top |> String.split("\n")

    [method, path, _] = request_line |> String.split(" ")

    headers = header_lines |> parse_headers(%{})

    params = params_string |> parse_params(headers["Content-Type"])

    # IO.inspect header_lines

    %Conv{
      method: method,
      path: path,
      params: params,
      headers: headers
    }
  end

  def parse_params(params_string, "application/x-www-form-urlencoded") do
    params_string |> String.trim |> URI.decode_query
  end

  def parse_params(_, _), do: %{}

  def parse_headers([head | tail], headers) do
    # IO.puts "Head: #{inspect(head)} Tail: #{inspect(tail)}"

    [key, value] = String.split(head, ": ")

    # IO.puts "Key: #{inspect(key)} Value: #{inspect(value)}"

    headers = Map.put(headers, key, value)

    parse_headers(tail, headers)
  end

  def parse_headers([], headers), do: headers
end
