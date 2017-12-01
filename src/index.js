import './main.css'
import 'font-awesome/css/font-awesome.min.css'

import { Main } from './Main.elm'
import registerServiceWorker from './registerServiceWorker'

Main.embed(document.getElementById('root'))

registerServiceWorker()
