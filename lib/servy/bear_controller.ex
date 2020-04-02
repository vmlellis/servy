defmodule Servy.BearController do

  alias Servy.Wildthings
  alias Servy.Bear

  @templates_path Path.expand("templates", File.cwd!)

  defp render(conv, template, bindings \\ []) do
    content =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(bindings)

    %{ conv | status: 200, resp_body: content }
  end

  def index(conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2)

    render(conv, "index.eex", bears: bears)
  end

  def show(conv) do
    %{"id" => id} = conv.params
    bear = Wildthings.get_bear(id)

    render(conv, "show.eex", bear: bear)
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
