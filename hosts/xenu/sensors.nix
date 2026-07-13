{ ... }:
{
  # Bind the NCT6798D Super-I/O chip so motherboard fan headers and
  # voltages are visible to lm_sensors. Plain modprobe binds fine on this
  # board — no acpi_enforce_resources=lax needed.
  boot.kernelModules = [ "nct6775" ];
}
