defmodule PocUploadCloudflareR2.Repo do
  use Ecto.Repo,
    otp_app: :poc_upload_cloudflare_r2,
    adapter: Ecto.Adapters.Postgres
end
