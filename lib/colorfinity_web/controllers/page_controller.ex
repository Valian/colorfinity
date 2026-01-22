defmodule ColorfinityWeb.PageController do
  use ColorfinityWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
