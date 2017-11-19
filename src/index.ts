import './main.css';
import { Main } from 'pingpong/elm';
import registerServiceWorker from './registerServiceWorker';
import xs, { MemoryStream, Producer } from 'xstream';
import { makeCustomAim$ } from './js/aim';

const app = Main.embed(document.getElementById('root'));

registerServiceWorker();

// Stream that takes user's values from Elm
const targetPosition$: MemoryStream<[number, number]> = xs
  .createWithMemory({
    start: function(listener) {
      app.ports.TargetPosition.subscribe(position => listener.next(position));
    },
    stop: function() {}
  } as Producer<[number, number]>)
  .startWith([0, 90]);

// Listen to the aim stream, and send the values to Elm
makeCustomAim$(targetPosition$).addListener({
  next: aimResult => app.ports.CustomAim.send(aimResult),
  error: err => console.error(err),
  complete: () => console.log('customAim$ complete')
});
