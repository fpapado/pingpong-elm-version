import bearing from '@turf/bearing';
import { Either, unpack } from '@typed/either';
import xs, { Stream } from 'xstream';
import throttle from 'xstream/extra/throttle';

import { absoluteOrientation$ } from './deviceorientation';
import { position$ } from './position';

export type LatLng = [number, number];

const getCustomBearing = (from: LatLng, to: LatLng) => {
  let bearingToTarget = bearing(from, to);
  return bearingToTarget;
};

const aimToTarget = (position: Position, target: LatLng, absOrientation: number): number => {
  let { coords } = position;
  let bearingToTarget = getCustomBearing([coords.latitude, coords.longitude], target);
  let aim = bearingToTarget + absOrientation;
  return aim;
};

export type AimResult = Either<number, 'CUSTOM_AIM_UNAVAILABLE'>;
export const makeCustomAim$ = (
  target$: Stream<LatLng>,
  silencePeriod: number = 0
): Stream<AimResult> => {
  let throttledOrientation$ = absoluteOrientation$.compose(throttle(silencePeriod));

  return xs
    .combine(position$, target$, absoluteOrientation$)
    .map(([position, target, orientationResult]) =>
      unpack(
        (absOrientation: number) => Either.left(aimToTarget(position, target, absOrientation)),
        err => Either.of('CUSTOM_AIM_UNAVAILABLE' as 'CUSTOM_AIM_UNAVAILABLE'),
        orientationResult
      )
    );
};
