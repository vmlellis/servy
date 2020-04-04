defmodule Servy.Api.BearController do
  def index(conv) do
    json = Servy.Wildthings.list_bears() |> Poison.encode!

    new_headers = %{ conv.resp_headers | "Content-Type" => "application/json" }

    %{ conv | status: 200, resp_headers: new_headers, resp_body: json }
  end

  def create(conv) do
    %{"name" => name, "type" => type} = conv.params
    %{ conv | status: 201,
              resp_body: "Created a #{type} bear named #{name}!" }
  end
end
