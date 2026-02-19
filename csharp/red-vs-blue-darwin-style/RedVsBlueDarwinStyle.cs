using Red = RedRemoteControlCarTeam;
using Blue = BlueRemoteControlCarTeam;

namespace RedRemoteControlCarTeam
{
    public class RemoteControlCar
    {
        public RemoteControlCar(Motor motor, Chassis chassis, Telemetry telemetry, RunningGear runningGear) { /* red members and API*/ }
        public class RunningGear { /* red members and API */ }
        public class Telemetry { /* red members and API */ }
        public class Chassis { /* red members and API */ }
        public class Motor { /* red members and API */ }
    }
}

namespace BlueRemoteControlCarTeam
{
    public class RemoteControlCar
    {
        public RemoteControlCar(Motor motor, Chassis chassis, Telemetry telemetry) { /* blue members and API */ }
        public class Telemetry { /* blue members and API */ }
        public class Chassis { /* blue members and API */ }
        public class Motor { /* blue members and API */ }
    }
}

namespace Combined
{
    public static class CarBuilder
    {
        public static Red.RemoteControlCar BuildRed() =>
            new Red.RemoteControlCar(new Red.RemoteControlCar.Motor(), new Red.RemoteControlCar.Chassis(), new Red.RemoteControlCar.Telemetry(), new Red.RemoteControlCar.RunningGear());

        public static Blue.RemoteControlCar BuildBlue() =>
            new Blue.RemoteControlCar(new Blue.RemoteControlCar.Motor(), new Blue.RemoteControlCar.Chassis(), new Blue.RemoteControlCar.Telemetry());
    }
}
