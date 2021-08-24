#! /usr/bin/env python
from dashapp import app
application = app.server
if __name__ == '__main__':
    application.run(debug=True, host='0.0.0.0', port='80')