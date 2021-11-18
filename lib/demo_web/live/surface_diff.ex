defmodule DemoWeb.SurfaceDiff do
  use Surface.LiveView

  def render(assigns) do
    ~F"""
    <div class="text-center" phx-update="append">
      {#for id <- @ids}
        <div id={id} class="unchanged">
          <div class="also unchanged">
            Text before
            {@values[id]}
            and after
          </div>
        </div>
      {/for}
    </div>
    """
  end

  def mount(_params, _uri, socket) do
    Process.send_after(self(), "update", 1000)
    {:ok, assign(socket, ids: 1..10, values: Map.new(1..10, &{&1, 1})), temporary_assigns: [ids: []]}
  end

  def handle_info("update", socket) do
    Process.send_after(self(), "update", 1000)
    id = :rand.uniform(10)
    values = Map.update!(socket.assigns.values, id, &(&1 + 1))
    {:noreply, assign(socket, ids: [id], values: values)}
  end
end
