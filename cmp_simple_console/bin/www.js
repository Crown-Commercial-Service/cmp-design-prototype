
const app = require('../app/app.js')()


const PORT= process.env["PORT"] || 8000

app.listen(PORT, () => {
    console.log('Server started at http://localhost:' + PORT)
})