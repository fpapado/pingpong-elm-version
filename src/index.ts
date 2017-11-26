import './main.scss';
import { Main } from 'pingpong/elm';
import registerServiceWorker from './registerServiceWorker';
import xs, { MemoryStream, Producer } from 'xstream';
import { makeCustomAim$, AimResult } from './js/aim';
import { unpack } from '@typed/either';

const app = Main.embed(document.getElementById('root'));

registerServiceWorker();

// Stream that takes user's values from Elm
const targetPosition$: MemoryStream<[number, number]> = xs
  .createWithMemory({
    start: function(listener) {
      app.ports.targetPositionOut.subscribe(position => listener.next(position));
    },
    stop: function() {}
  } as Producer<[number, number]>)
  .startWith([41.1496, -8.6109]);

// Listen to the aim stream, and send the values to Elm
makeCustomAim$(targetPosition$, 12)
  .debug()
  .addListener({
    next: aimResult => sendAimOrError(aimResult),
    error: err => console.error(err),
    complete: () => console.log('customAim$ complete')
  });

// Debug stream
// xs.periodic(16).debug().addListener({next: aim => app.ports.customAimIn.send(aim)});

const sendAimOrError = aimResult => {
  unpack(
    aim => app.ports.customAimIn.send(aim),
    error => app.ports.customAimError.send(error),
    aimResult
  );
};
