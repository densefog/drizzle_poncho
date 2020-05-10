# DrizzlePoncho

1. Run application from `/drizzle` which is the firmware root.
2. Need to run 'source rpi3.sh or host.sh' to load environment from `/drizzle`.
3. Build takes place in `/drizzle` by running `mix firmware` or `mix compile`.
4. Upload to rpi3 by running `./upload.sh` after `mix firmware`.
5. Can hit remote server using http://nerves.local:4000/thermostat or local with http://localhost:4000.
6. Can also ssh to nerves.local
7. Poncho apps seems to have the same issue as Umbrellas in that we need to build from the firmware app
but the UI is trying to call functionality in it as a sub-app. We get warnings from the UI app but it works when running. May
need to setup message communications.
8. Watch logs by running `Ringlogger.attach` and `RingLogger.next`
