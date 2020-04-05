defmodule Servy.Parser do

  alias Servy.Conv

  def parse(request) do
    [top, params_string] = request |> String.split("\r\n\r\n")

    [request_line | header_lines] = top |> String.split("\r\n")

    [method, path, _] = request_line |> String.split(" ")

    headers = header_lines |> parse_headers

    params = params_string |> parse_params(headers["Content-Type"])

    %Conv{
      method: method,
      path: path,
      params: params,
      headers: headers
    }
  end

  @doc """
  Parses the given param string of the form `key1=value1&key2=value2`
  into a map with corresponding keys and values

  ## Examples
      iex> params_string = "name=Baloo&type=Brown"
      iex> Servy.Parser.parse_params(params_string, "application/x-www-form-urlencoded")
      %{"name" => "Baloo", "type" => "Brown"}
      iex> Servy.Parser.parse_params(params_string, "multipart/form-data")
      %{}
  """
  def parse_params(params_string, "application/x-www-form-urlencoded") do
    params_string |> String.trim |> URI.decode_query
  end

  def parse_params("", "application/json"), do: %{}

  def parse_params(params_string, "application/json") do
    params_string |> String.trim |> Poison.Parser.parse!(%{})
  end

  def parse_params(_, _), do: %{}

  # def parse_headers([head | tail], headers) do
  #   # IO.puts "Head: #{inspect(head)} Tail: #{inspect(tail)}"

  #   [key, value] = String.split(head, ": ")

  #   # IO.puts "Key: #{inspect(key)} Value: #{inspect(value)}"

  #   headers = Map.put(headers, key, value)

  #   parse_headers(tail, headers)
  # end

  # def parse_headers([], headers), do: headers

  def parse_headers(header_lines) do
    Enum.reduce(header_lines, %{}, fn(line, headers_so_far) ->
      [key, value] = String.split(line, ": ")
      Map.put(headers_so_far, key, value)
    end)
  end
end
