defmodule NadiaMock do
  def send_message(_id, message) do
    {:ok, %Nadia.Model.Message{text: message}}
  end
end
