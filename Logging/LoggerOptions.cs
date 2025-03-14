﻿namespace TNRD.Zeepkist.GTR.Backend.Logging;

public class LoggerOptions
{
    public const string Key = "Logger";

    public string Url { get; set; } = null!;
    public string Stream { get; set; } = null!;
    public string Login { get; set; } = null!;
    public string Token { get; set; } = null!;
    public string Organisation { get; set; } = null!;
}
