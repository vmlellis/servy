defmodule Servy.BearController do

  alias Servy.Wildthings
  alias Servy.Bear

  defp bear_item(bear) do
    "<li>#{bear.name} - #{bear.type}</li>"
  end

  def index(conv) do
    items =
      Wildthings.list_bears()
      |> Enum.filter(&Bear.is_grizzly/1)
      |> Enum.sort(&Bear.order_asc_by_name/2)
      |> Enum.map(&bear_item/1)
      |> Enum.join

    # TODO: Transform bears to an HTML list

    %{ conv | status: 200, resp_body: "<ul>#{items}</ul>" }
  end

  def show(conv) do
    %{"id" => id} = conv.params
    bear = Wildthings.get_bear(id)

    %{ conv | status: 200, resp_body: "<h1>Bear #{bear.id}: #{bear.name}</h1>" }
  end

  def create(conv) do
    %{"name" => name, "type" => type} = conv.params
    %{ conv | status: 201,
              resp_body: "Create a #{type} bear named #{name}!" }
  end

  def delete(conv) do
    %{ conv | status: 403, resp_body: "Bears must never be deleted!" }
  end
end
