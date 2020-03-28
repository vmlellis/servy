defmodule Servy.Plugins do
  require Logger
  alias Servy.Conv

  def emojify(%{status: 200, resp_body: resp_body} = conv) do
    emojis = "😎" |> String.duplicate(5)
    %{ conv | resp_body: "#{emojis}\n #{resp_body} \n#{emojis}" }
  end

  def emojify(conv), do: conv

  @doc "Logs 404 requests"
  def track(%Conv{status: 404, path: path} = conv) do
    Logger.warn "Do we have a problem, Houston?"
    IO.puts "Warning: #{path} is on the loose!"
    conv
  end

  def track(%Conv{status: 403} = conv) do
    Logger.warn "Do we have a problem, Houston?"
    conv
  end

  def track(%Conv{status: 500} = conv) do
    Logger.error "Danger Will Robinson!"
    conv
  end

  def track(%Conv{status: 200} = conv) do
    Logger.info "It's lunchtime somewhere."
    conv
  end

  def track(%Conv{} = conv), do: conv

  def rewrite_path(%Conv{method: "GET", path: "/wildlife"} = conv) do
    %{ conv | path: "/wildthings" }
  end

  # defp rewrite_path(%{method: "GET", path: "/bears?id=" <> id} = conv) do
  #   %{ conv | path: "/bears/#{id}" }
  # end

  def rewrite_path(%Conv{method: "GET", path: path} = conv) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conv, captures)
  end

  def rewrite_path(%Conv{} = conv), do: conv

  def rewrite_path_captures(%Conv{} = conv, %{"thing" => thing, "id" => id}) do
    %{ conv | path: "/#{thing}/#{id}" }
  end

  def rewrite_path_captures(%Conv{} = conv, nil), do: conv

  def log(%Conv{} = conv), do: IO.inspect conv
end
