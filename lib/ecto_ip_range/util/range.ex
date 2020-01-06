defmodule EctoIPRange.Util.Range do
  @moduledoc false

  alias EctoIPRange.Util.Inet

  @doc """
  Create a CIDR (if possible) or range notation for two IPv4 tuples.

  ## Examples

      iex> parse_ipv4({1, 2, 3, 4}, {1, 2, 3, 4})
      "1.2.3.4/32"

      iex> parse_ipv4({1, 2, 3, 4}, {2, 3, 4, 5})
      "1.2.3.4-2.3.4.5"
  """
  @spec parse_ipv4(:inet.ip4_address(), :inet.ip4_address()) :: binary | :error
  def parse_ipv4(ip4_address, ip4_address) do
    case Inet.ntoa(ip4_address) do
      ip when is_binary(ip) -> ip <> "/32"
      _ -> :error
    end
  end

  def parse_ipv4(first_ip4_address, last_ip4_address) do
    with first_ip when is_binary(first_ip) <- Inet.ntoa(first_ip4_address),
         last_ip when is_binary(last_ip) <- Inet.ntoa(last_ip4_address) do
      first_ip <> "-" <> last_ip
    else
      _ -> :error
    end
  end

  @doc """
  Create a CIDR (if possible) or range notation for two IPv6 tuples.

  ## Examples

      iex> parse_ipv6({1, 2, 3, 4, 5, 6, 7, 8}, {1, 2, 3, 4, 5, 6, 7, 8})
      "1:2:3:4:5:6:7:8/128"

      iex> parse_ipv6({1, 2, 3, 4, 5, 6, 7, 8}, {2, 3, 4, 5, 6, 7, 8, 9})
      "1:2:3:4:5:6:7:8-2:3:4:5:6:7:8:9"
  """
  @spec parse_ipv6(:inet.ip6_address(), :inet.ip6_address()) :: binary | :error
  def parse_ipv6(ip6_address, ip6_address) do
    case Inet.ntoa(ip6_address) do
      ip when is_binary(ip) -> ip <> "/128"
      _ -> :error
    end
  end

  def parse_ipv6(first_ip6_address, last_ip6_address) do
    with first_ip when is_binary(first_ip) <- Inet.ntoa(first_ip6_address),
         last_ip when is_binary(last_ip) <- Inet.ntoa(last_ip6_address) do
      first_ip <> "-" <> last_ip
    else
      _ -> :error
    end
  end
end