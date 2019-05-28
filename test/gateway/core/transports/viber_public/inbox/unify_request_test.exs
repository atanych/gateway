defmodule Transports.ViberPublic.Inbox.UnifyRequestTest do
  use GatewayWeb.ConnCase

  test "webhook" do
    request = %{
      chat_hostname: "SN-CHAT-06_",
      device_uniq_key: "bbb",
      event: "webhook",
      message_token: 5_306_638_826_245_346_756,
      timestamp: 1_557_259_064_886,
      transport: "viber_public"
    }

    unified_request = Transports.ViberPublic.Inbox.UnifyRequest.call(request)
    assert unified_request.event_type == "confirm_hook"
  end

  test "status" do
    request = %{
      chat_hostname: "SN-CHAT-07_",
      device_uniq_key: "bbb",
      event: "seen",
      message_token: 5_308_078_978_985_525_155,
      sig: "5cd38788cc48f48caeceb5a5cde219ac1761004303fa8b385162f971627d2da0",
      timestamp: 1_557_602_450_529,
      transport: "viber_public",
      user_id: "wAH/iUrD+rHAocQ8VQQhUg=="
    }

    unified_request = Transports.ViberPublic.Inbox.UnifyRequest.call(request)
    assert unified_request.event_type == "change_status"
    assert unified_request.chat.id == "wAH/iUrD+rHAocQ8VQQhUg=="
    assert unified_request.chat.status == "seen"
  end

  test "message" do
    request = %{
      chat_hostname: "SN-CHAT-04_",
      device_uniq_key: "bbb",
      event: "message",
      message: %{text: "S", type: "text"},
      message_token: 5_306_661_646_841_952_248,
      sender: %{
        api_version: 7,
        avatar: "http://dl-media.viber.com/1/share/2/long/bots/generic-avatar%402x.png",
        country: "BY",
        id: "wAH/iUrD+rHAocQ8VQQhUg==",
        language: "en",
        name: "Subscriber"
      },
      sig: "6baf39c3b5034300dd6e866aba2bab372705d93f17f4526fe646dd7e9389b3e4",
      silent: false,
      timestamp: 1_557_264_505_644,
      transport: "viber_public"
    }

    unified_request = Transports.ViberPublic.Inbox.UnifyRequest.call(request)
    assert unified_request.event_type == "send_inbox"
    assert unified_request.message.text == "S"
    assert unified_request.message.id == 5_306_661_646_841_952_248
    assert unified_request.client.avatar == "http://dl-media.viber.com/1/share/2/long/bots/generic-avatar%402x.png"
    assert unified_request.client.lang == "en"
    assert unified_request.client.id == "wAH/iUrD+rHAocQ8VQQhUg=="
    assert unified_request.client.uniq_key == "vbp/wAH/iUrD+rHAocQ8VQQhUg=="
    assert unified_request.client.nickname == "Subscriber"
  end

  test "image" do
    request = %{
      chat_hostname: "SN-CHAT-04_",
      device_uniq_key: "bbb",
      event: "message",
      message: %{
        file_name: "1557267880757450.jpg",
        media: "https://dl-media.viber.com/4/media/2/short/any/sig/image/0x0",
        text: "Ahahah",
        thumbnail:
          "https://dl-media.viber.com/4/media/2/short/any/sig/image/400/15ae/6a40d2103af277a0a7c82296bccda3496c80926d990e5b30dfb2289d903615ae.jpg?Expires=1557271489&Signature=rf~9vPp9VVWow7FGf3IaaiBXN49txby6~K6AgTg0Cq7KHbIAGsUurYuVq0Goj32N16Gy8CGgi2hW1CR8Qv4yHKh2SncLusT67~fkSVu0jG1QunWA9AEFt4YEx-oUaPax8pB5JQNv78ALWAWtVmEje2fl4II-jp2f34LwmZU1gsL-XZE1b~HXVuUysCEqCdu49u8pjtqZn8MdhDZR5izzUIOfor1p8tx1-WVjJiQ0PGPEidzCqNLUrxCKZkczTPQZ6Lzp3lI0pTEBfVopSBtGawKnn-DVD-0dJKApUp7wLzLP5AIA-n5C3y0B~rqHcAueFHKb2ZC12RxDPtskt7bc~w__&Key-Pair-Id=APKAJ62UNSBCMEIPV4HA",
        type: "picture"
      },
      message_token: 5_306_675_835_350_299_734,
      sender: %{
        api_version: 7,
        avatar: "http://dl-media.viber.com/1/share/2/long/bots/generic-avatar%402x.png",
        country: "BY",
        id: "wAH/iUrD+rHAocQ8VQQhUg==",
        language: "en",
        name: "Subscriber"
      },
      sig: "63e3c50146f0e26d3b7235965c1ec8f6d7b1876969da205f1ba4000b4f335db3",
      silent: false,
      timestamp: 1_557_267_888_266,
      transport: "viber_public"
    }

    %{message: %{attachments: [attachment]}} = Transports.ViberPublic.Inbox.UnifyRequest.call(request)
    assert attachment.url == "https://dl-media.viber.com/4/media/2/short/any/sig/image/0x0"
    assert attachment.name == "1557267880757450.jpg"
    assert attachment.type == "image"
  end

  test "location" do
    request = %{
      chat_hostname: "SN-CHAT-04_",
      device_uniq_key: "bbb",
      event: "message",
      message: %{location: %{lat: 53.8844239, lon: 27.4325049}, type: "location"},
      message_token: 5_306_679_273_417_094_409,
      sender: %{
        api_version: 7,
        avatar: "http://dl-media.viber.com/1/share/2/long/bots/generic-avatar%402x.png",
        country: "BY",
        id: "wAH/iUrD+rHAocQ8VQQhUg==",
        language: "en",
        name: "Subscriber"
      },
      sig: "59422e31f355714ccbfd0833c15370c207f347333f8c4ef7ff68f40b6ed212d4",
      silent: false,
      timestamp: 1_557_268_708_140,
      transport: "viber_public"
    }

    %{message: message} = Transports.ViberPublic.Inbox.UnifyRequest.call(request)
    assert message.location == %{lat: 53.8844239, lon: 27.4325049}
  end

  test "video" do
    request = %{
      chat_hostname: "SN-CHAT-04_",
      device_uniq_key: "bbb",
      event: "message",
      message: %{
        duration: 2400,
        file_name: "1557269405502533.mp4",
        media: "https://dl-media.viber.com/5/medi",
        size: 268_364,
        text: "Aaaaa",
        thumbnail:
          "https://dl-media.viber.com/5/media/2/short/any/sig/image/400/4b6c/f4ba6920b8ebf6d6c777d5ad08ef989a9684d7e00d22a51e415c21338a654b6c.jpg?Expires=1557273016&Signature=TsvfKMQ-nWPW2Gf6LGTjYb9jeGbmNdT-2U9Fp692RQ4UbBC3JEQQJcH6Enxd2x9g4YFPXigtiGtCsDDmkS76e3Tv5ahvMd1z1Nx1dd7V6WA1W6TadM15x7pQ193sn0Hu-xkccDdnOf8gAEo~3BwWRpTPCJF3rCQWAVRKqLskFUUOuonVH24SrGoQPuDCeJbh1d~lm66bQSJWBcuwDbBqK7b-RISQd6sx4a~GI0Q1SGxhkbZmliV7cf5lekkts1msPKrROptfjxd~oGPVfF4~~Rs0iB68vO-WqOuGaEhrdU0THIVW4rXhy~NOx-m-rvxq74kfOQ3CCm~m4Q2UDegz1A__&Key-Pair-Id=APKAJ62UNSBCMEIPV4HA",
        type: "video"
      },
      message_token: 5_306_682_243_189_847_542,
      sender: %{
        api_version: 7,
        avatar: "http://dl-media.viber.com/1/share/2/long/bots/generic-avatar%402x.png",
        country: "BY",
        id: "wAH/iUrD+rHAocQ8VQQhUg==",
        language: "en",
        name: "Subscriber"
      },
      sig: "c4a694bc837a38c6e868a88b4b93b961bccc66b8dad56cfaa0425b88496f3289",
      silent: false,
      timestamp: 1_557_269_416_089,
      transport: "viber_public"
    }

    %{message: %{attachments: [attachment]}} = Transports.ViberPublic.Inbox.UnifyRequest.call(request)
    assert attachment.url == "https://dl-media.viber.com/5/medi"
    assert attachment.name == "1557269405502533.mp4"
    assert attachment.type == "file"
  end

  test "contact" do
    request = %{
      chat_hostname: "SN-CHAT-04_",
      device_uniq_key: "bbb",
      event: "message",
      message: %{
        contact: %{
          avatar: "https://media-direct.cdn.viber.com/downlo",
          name: "FFF",
          phone_number: "+3756664335"
        },
        type: "contact"
      },
      message_token: 5_306_683_618_053_338_118,
      sender: %{
        api_version: 7,
        avatar: "http://dl-media.viber.com/1/share/2/long/bots/generic-avatar%402x.png",
        country: "BY",
        id: "wAH/iUrD+rHAocQ8VQQhUg==",
        language: "en",
        name: "Subscriber"
      },
      sig: "63202e5279175ed5899539906795c19081b10507cdc6e9bab99b624fb44bf836",
      silent: false,
      timestamp: 1_557_269_744_004,
      transport: "viber_public"
    }

    %{contact: contact} = Transports.ViberPublic.Inbox.UnifyRequest.call(request)
    assert contact.avatar == "https://media-direct.cdn.viber.com/downlo"
    assert contact.phone == "+3756664335"
    assert contact.nickname == "FFF"
  end
end
