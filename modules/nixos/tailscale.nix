{ config, pkgs, ... }:
{
  services.tailscale.enable = true;

  # Optional: makes the `tailscale` CLI available in PATH
  environment.systemPackages = [ pkgs.tailscale ];

  # Optional but common: allow traffic arriving via your tailnet
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  # Optional: if your firewall is strict, allow Tailscale’s UDP port
  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];
}
