defmodule Sdk.Storage.Config do
  def data,
    do: %{
      base_url: System.get_env()["STORAGE_DOMAIN"],
      sdk_name: "Storage",
      endpoints: %{
        upload: %{
          type: :post,
          url: "/upload"
        }
      }
    }
end
