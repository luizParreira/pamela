defmodule NadiaMock do
  def send_message(id, message) do
    {:ok, %Nadia.Model.Message{text: message}}
  end
end
