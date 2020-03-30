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

  @spec show(%{resp_body: any, status: any}, map) :: %{resp_body: <<_::64, _::_*8>>, status: 200}
  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    %{ conv | status: 200, resp_body: "<h1>Bear #{bear.id}: #{bear.name}</h1>" }
  end

  def create(conv, %{"name" => name, "type" => type}) do
    %{ conv | status: 201,
              resp_body: "Create a #{type} bear named #{name}!" }
  end
end