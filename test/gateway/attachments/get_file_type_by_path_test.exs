defmodule Attachments.GetFileTypeByPathTest do
  use GatewayWeb.ConnCase

  test "pdf" do
    type = Attachments.GetFileTypeByPath.call("sdsd.pdf")
    assert type == :file
  end

  test "jpg" do
    type = Attachments.GetFileTypeByPath.call("sdsd.jpg")
    assert type == :image
  end

  test "mp4" do
    type = Attachments.GetFileTypeByPath.call("sdsd.mp4")
    assert type == :video
  end

  test "any" do
    type = Attachments.GetFileTypeByPath.call("sdsd.xxx")
    assert type == :file
  end
end
