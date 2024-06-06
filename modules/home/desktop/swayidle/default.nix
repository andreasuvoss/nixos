{ pkgs, ...}:
{
  # TODO
  # Use this or nah?
  # services.swayidle = {
  #   enable = true;
  #   settings = {
  #     color = "000000";
  #     ignore-empty-password = true;
  #   };
  # };

  home.packages = with pkgs; [
    swayidle
  ];
}
