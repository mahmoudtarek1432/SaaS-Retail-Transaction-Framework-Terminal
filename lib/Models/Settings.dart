class SettingsFields {
  static final List<String> values = [
    /// Add all fields
 primaryColor, secondaryColor, accentColor, labelColor, textColor, brandName, icon,terminalMode,version
  ];
  static final String primaryColor = 'primaryColor';
  static final String secondaryColor = 'secondaryColor';
  static final String accentColor = 'accentColor';
  static final String labelColor = 'labelColor';
  static final String textColor = 'textColor';
  static final String brandName = 'brandName';
  static final String icon = 'icon';
  static final String terminalMode = 'terminalMode';
  static final String version = 'version';

}

class Settings {
  String primaryColor;
  String secondaryColor;
  String accentColor;
  String labelColor;
  String textColor;
  String brandName;
  String icon;
  int terminalMode;
  int version = 0;

  Settings(
      {
      this.primaryColor,
      this.secondaryColor,
      this.accentColor,
      this.labelColor,
      this.textColor,
      this.brandName,
      this.icon,
        this.terminalMode,
      this.version
      });

  static Settings fromJson(Map<String, Object> json) => Settings(
        primaryColor: json[SettingsFields.primaryColor] as String,
        secondaryColor: json[SettingsFields.secondaryColor] as String,
        accentColor: json[SettingsFields.accentColor] as String,
        labelColor: json[SettingsFields.labelColor] as String,
        textColor: json[SettingsFields.textColor] as String,
        brandName: json[SettingsFields.brandName] as String,
        icon: json[SettingsFields.icon] as String,
    terminalMode: json[SettingsFields.terminalMode] as int,
    version: json[SettingsFields.version] as int,
      );

  Map<String, Object> toJson() => {
        SettingsFields.primaryColor: primaryColor,
        SettingsFields.secondaryColor: secondaryColor,
        SettingsFields.accentColor: accentColor,
        SettingsFields.labelColor: labelColor,
        SettingsFields.textColor: textColor,
        SettingsFields.brandName: brandName,
        SettingsFields.icon: icon,
    SettingsFields.terminalMode: terminalMode,
        SettingsFields.version: version
      };
}
