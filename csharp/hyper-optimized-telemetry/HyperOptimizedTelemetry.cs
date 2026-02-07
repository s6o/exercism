public static class TelemetryBuffer
{
    private static (int byteCount, bool singed) _DecodeByteCountAndSigned(long reading)
    {
        return reading switch
        {
            >= 4_294_967_296 and <= 9_223_372_036_854_775_807 => (BitConverter.GetBytes(long.MaxValue).Length, true),
            >= 2_147_483_648 and <= 4_294_967_295 => (BitConverter.GetBytes(uint.MaxValue).Length, false),
            >= 65_536 and <= 2_147_483_647 => (BitConverter.GetBytes(int.MaxValue).Length, true),
            >= 0 and <= 65_535 => (BitConverter.GetBytes(ushort.MaxValue).Length, false),
            >= -32_768 and <= -1 => (BitConverter.GetBytes(short.MaxValue).Length, true),
            >= -2_147_483_648 and <= -32_769 => (BitConverter.GetBytes(int.MaxValue).Length, true),
            >= -9_223_372_036_854_775_808 and <= -2_147_483_649 => (BitConverter.GetBytes(long.MaxValue).Length, true)
        };
    }

    private static byte _EncodePrefix((int byteCount, bool signed) t) => t.signed switch
    {
        false => (byte)t.byteCount,
        true => (byte)(byte.MaxValue - t.byteCount + 1),
    };

    private static (int byteCount, bool signed) _DecodePrefix(int prefix) => prefix switch
    {
        > (byte.MaxValue - 8) => (byte.MaxValue - prefix + 1, true),
        > 0 and <= 8 => (prefix, false),
        _ => (0, false),
    };

    public static byte[] ToBuffer(long reading)
    {
        byte[] data = BitConverter.GetBytes(reading);
        var t = _DecodeByteCountAndSigned(reading);
        var prefix = _EncodePrefix(t);
        return [prefix, .. data[..t.byteCount], .. new byte[8 - t.byteCount]];
    }

    public static long FromBuffer(byte[] buffer)
    {
        int prefix = buffer.Length == 9 ? buffer[0] : 0;
        return _DecodePrefix(prefix) switch
        {
            ( > 0 and <= 4, false) => BitConverter.ToInt64(buffer, 1),
            (8, true) => BitConverter.ToInt64(buffer, 1),
            (4, true) => BitConverter.ToInt32(buffer, 1),
            (2, true) => BitConverter.ToInt16(buffer, 1),
            _ => 0
        };
    }
}
