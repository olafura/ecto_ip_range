defmodule EctoIPRange.Postgrex.IP6RExtension do
  @moduledoc """
  Postgrex extension for "ip6r" fields.
  """

  use Postgrex.BinaryExtension, type: "ip6r"

  import Postgrex.BinaryUtils, warn: false

  alias EctoIPRange.IP6R
  alias EctoIPRange.Util.Inet

  def encode(_) do
    quote location: :keep do
      %IP6R{
        first_ip: {first_a, first_b, first_c, first_d, first_e, first_f, first_g, first_h},
        last_ip: {last_a, last_b, last_c, last_d, last_e, last_f, last_g, last_h}
      } ->
        <<32::int32, first_a::int16, first_b::int16, first_c::int16, first_d::int16,
          first_e::int16, first_f::int16, first_g::int16, first_h::int16, last_a::int16,
          last_b::int16, last_c::int16, last_d::int16, last_e::int16, last_f::int16,
          last_g::int16, last_h::int16>>
    end
  end

  def decode(_) do
    quote location: :keep do
      <<32::int32, first_a::int16, first_b::int16, first_c::int16, first_d::int16, first_e::int16,
        first_f::int16, first_g::int16, first_h::int16, first_a::int16, first_b::int16,
        first_c::int16, first_d::int16, first_e::int16, first_f::int16, first_g::int16,
        first_h::int16>> ->
        first_ip6_address =
          {first_a, first_b, first_c, first_d, first_e, first_f, first_g, first_h}

        with first_ip when is_binary(first_ip) <- Inet.ntoa(first_ip6_address) do
          %IP6R{
            range: first_ip <> "/128",
            first_ip: first_ip6_address,
            last_ip: first_ip6_address
          }
        end

      <<32::int32, first_a::int16, first_b::int16, first_c::int16, first_d::int16, first_e::int16,
        first_f::int16, first_g::int16, first_h::int16, last_a::int16, last_b::int16,
        last_c::int16, last_d::int16, last_e::int16, last_f::int16, last_g::int16,
        last_h::int16>> ->
        first_ip6_address =
          {first_a, first_b, first_c, first_d, first_e, first_f, first_g, first_h}

        last_ip6_address = {last_a, last_b, last_c, last_d, last_e, last_f, last_g, last_h}

        with(
          first_ip when is_binary(first_ip) <- Inet.ntoa(first_ip6_address),
          last_ip when is_binary(last_ip) <- Inet.ntoa(last_ip6_address)
        ) do
          %IP6R{
            range: first_ip <> "-" <> last_ip,
            first_ip: first_ip6_address,
            last_ip: last_ip6_address
          }
        end
    end
  end
end