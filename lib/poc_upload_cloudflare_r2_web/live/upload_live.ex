defmodule PocUploadCloudflareR2Web.UploadLive do
  use PocUploadCloudflareR2Web, :live_view

  def mount(_params, _session, socket) do
    {
      :ok,
      socket
        |> assign(:uploaded_files, [])
        |> allow_upload(:audio, accept: ~w(.m4a .jpeg), max_entries: 1, max_file_size: 100_000_000)
    }
  end

  def handle_event("validate", params, socket) do
    IO.inspect "Handling file validate event"
    IO.inspect "Params given:"
    IO.inspect params

    {:noreply, socket}
  end

  def handle_event("save", _params, socket) do
    IO.inspect "Handlinv save event"
    uploaded_files = consume_uploaded_entries(socket, :audio, fn %{path: path}, _entry ->
      destination = Path.join(Application.app_dir(:poc_upload_cloudflare_r2, "priv/static/uploads"), Path.basename(path))
      IO.inspect "destination"
      IO.inspect destination
      File.cp!(path, destination)
      {:ok, ~p"/uploads/#{Path.basename(destination)}"}
    end)

    IO.inspect("uploaded_files")
    IO.inspect(uploaded_files)

    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
end
