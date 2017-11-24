import './main.css'
import 'font-awesome/css/font-awesome.min.css'
import 'bulma/css/bulma.css'

import { Main } from './Main.elm'
import registerServiceWorker from './registerServiceWorker'

Main.embed(document.getElementById('root'))

registerServiceWorker()
