import subprocess
import bottle


@bottle.route('/')
def index():
    bottle.response.content_type = 'text/plain'
    return '\n'.join(
        [uname()] +
        list(ipaddresses())
    )


def uname():
    return run(['uname', '-a'])


def ipaddresses():
    output = run(['ip', 'addr', 'show'])
    for line in output.splitlines():
        parts = line.split()
        if parts[0] == 'inet':
            yield ' '.join(parts[-1:-5:-3])


def run(command):
    p = subprocess.run(command,
            stdout=subprocess.PIPE,
            universal_newlines=True)
    p.check_returncode()
    return p.stdout


def infoserver():
    bottle.run(host='0.0.0.0')
