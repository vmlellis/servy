defmodule Servy.Parser do

  alias Servy.Conv

  def parse(request) do
    [top, params_string] = request |> String.split("\n\n")

    [request_line | _header_lines] = top |> String.split("\n")

    [method, path, _] = request_line |> String.split(" ")

    params = params_string |> parse_params

    %Conv{ method: method, path: path, params: params }
  end

  def parse_params(params_string) do
    params_string |> String.trim |> URI.decode_query
  end
end
