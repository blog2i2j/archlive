#!/bin/sh
exec /bin/sh -c "sleep 1 && /usr/bin/imlib2_grab screenshot_`date "+%m%d%H%M%S"`.png"
