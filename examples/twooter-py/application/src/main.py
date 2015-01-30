import calendar
import time
import web

FMT = '%H:%M on %a, %d %b %Y'
def disp(gm):
    return time.strftime(FMT, time.gmtime(gm))

render = web.template.render('templates',
                             globals={'disp': disp})

db = web.database(dbn='sqlite', db='tmp.db')

def is_valid_twoot(twoot):
    return 0 < len(twoot) < 142

class timeline:
    def GET(self):
        return render.timeline(db.select('twoot'))

    def POST(self):
        twoot = web.input().get("twoot", None)
        print "GOT",twoot
        if twoot and is_valid_twoot(twoot):
            db.insert('twoot',
                      text=twoot,
                      time=calendar.timegm(time.localtime()))
            return render.post_success()
        else:
            return render.post_failure()

class twoot:
    def GET(self, twoot_id):
        twoot = list(db.select('twoot',
                               where='id = $n',
                               vars={'n': twoot_id}))
        if twoot:
            return render.twoot(twoot[0])
        else:
            return render.twoot_failure()

class twoot_form:
    def GET(self):
        return render.form()

urls = (
    '/', timeline,
    '/t/new', twoot_form,
    '/t/([0-9]+)', twoot
)

app = web.application(urls, globals())

if __name__ == '__main__':
    app.run()
