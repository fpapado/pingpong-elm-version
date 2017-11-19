import './main.css';
import { Main } from 'pingpong/elm';
import registerServiceWorker from './registerServiceWorker';

Main.embed(document.getElementById('root'));

registerServiceWorker();
