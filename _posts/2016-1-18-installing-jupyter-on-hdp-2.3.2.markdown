---
layout: post
title:  "Installing Jupyter (IPython Notebook) on HDP 2.3.2"
date:   2016-1-18
published: true
---

**Update:** I revised the [old article from July 2015][old article] to work with the currently available Hortonworks Dataplatform HDP 2.3.2 and Jupyter, which itself is the updated version/successor of IPython Notebook. Furthermore I included the tips mentioned in the comments by John Kerley-Weeks and collapsed steps 6 and 7 to one single (much simpler!) step. Thanks again for your help!

<p class="intro"><span class="dropcap">S</span>ince we're using the Hortonworks Data Plattform at work, I toyed around with the HDP 2.3.2 Sandbox to see whats inside. One thing I've found is, they upgraded the Apache Spark Version from 1.2 to the more recently 1.3.1 release. Needless to say, it sparked my interest... (you see, what I did there?)</p>

Being more comfortable with the Python language than Scala, I decided to fire up the included pyspark shell, but found it not to be that engaging. I always liked the REPL interface from Python, the direct way of programming, but it laked the sustainability of "normal" written scripts. So to get a better grip on how everything works, I decided to upgrade the distribution and go ahead to install Jupyter, which lets me program like on a shell, but has the longevity of written code. I reaaaaally like that interface :)

So here is a step by step manual, of how to get Jupyter running on HDP 2.3.2 Sandbox:

### Step 01: Download and Install HDP
- Download the Sandbox [here][hdp download]
- Download Virtualbox [here][virtualbox download]
- After installing Virtualbox and importing the virtual machine into it, you have to add a new portforwarding rule. To do this, you have to right click on the imported VM, go to settings/network settings, extended and click on port-forwarding. Add the following rule: ipython notebook, 127.0.0.1, Port 8889, Port 8889
- After that, you may boot the VM

### Step 02: Connect via ssh and install needed libraries
- You may connect via ssh: root@127.0.0.1:2222 password: hadoop
- install needed libraries: 

{% highlight bash %}
yum install nano centos-release-SCL zlib-devel \
bzip2-devel openssl-devel ncurses-devel \
sqlite-devel readline-devel tk-devel \
gdbm-devel db4-devel libpcap-devel xz-devel \
libpng-devel libjpg-devel atlas-devel
{% endhighlight %}

{% highlight bash %}
yum groupinstall "Development tools"
{% endhighlight %}

### Step 03: Install Python 2.7
Since HDP 2.3 Preview Sandbox only comes with Python 2.6 installed, but Jupyter requires at least python 2.7, we have to install it manually. To do without recompiling it ourselves, we can use the CentOS Software Collections Repository, which we installed in the previews step (centos-release-SCL). So just type
{% highlight bash %}
yum install python27
{% endhighlight %}

to get python 2.7. 

Now we have to activate it for this session:
{% highlight bash %}
source /opt/rh/python27/enable
{% endhighlight %}

### Step 04: Install pip for Python 2.7
To get Jupyter and some more python libraries, we will use pip - the python package manager. So let's install pip:
{% highlight bash %}
wget https://bitbucket.org/pypa/setuptools\
/raw/bootstrap/ez_setup.py

python ez_setup.py
easy_install-2.7 pip
{% endhighlight %}


### Step 05: Install Jupyter (IPython Notebook)
First, we will install some more "standard" python libraries for data scientist to have something to toy around with. Afterwards, we will install IPython Notebook.

{% highlight bash %}
pip install numpy scipy pandas \
scikit-learn tornado pyzmq \
pygments matplotlib jinja2 jsonschema

pip install jupyter
{% endhighlight %}


### Step 06: Create Jupyter startup script
Create a new file in your home directory

{% highlight bash %}
nano ~/start_ipython_notebook.sh
{% endhighlight %}

and add the following content to it.
{% highlight bash %}
#!/bin/bash
source /opt/rh/python27/enable
IPYTHON_OPTS="notebook --port 8889 \
--notebook-dir='/usr/hdp/2.3.2.0-2950/spark/' \
--ip='*' --no-browser" pyspark
{% endhighlight %}

Afterwars make this script executable
{% highlight bash %}
chmod +x start_ipython_notebook.sh
{% endhighlight %}

### Step 07: Start IPython Notebook
You're done! You may start Jupyter from your home directory with the command

{% highlight bash %}
./start_ipython_notebook.sh
{% endhighlight %}

After that you may open your webbrowser and open http://127.0.0.1:8889 to get to the Jupyter startpage or http://127.0.0.1:4040 to open Spark UI, which gets you some insight into memory consumption and duration of our Apache Spark jobs.

Cheers!

___

### Troubleshooting guide

**Error:** TemplateAssertionError: no filter named 'urlencode'

Full error-message:
{% highlight bash %}
Uncaught exception GET /tree (127.0.0.1)
    HTTPServerRequest(protocol='http', host='127.0.0.1:8889', method='GET', uri='/tree', version='HTTP/1.1', remote_ip='10.98.198.7', headers={'Via': '1.1 saurna.netrtl.com (squid/3.1.10)', 'Accept-Language': 'de-DE,de;q=0.8,en-US;q=0.6,en;q=0.4', 'Accept-Encoding': 'gzip, deflate, sdch', 'Host': '172.16.37.1:8889', 'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8', 'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36', 'Connection': 'keep-alive', 'Cookie': '_mkto_trk=id:549-QAL-086&token:_mch-172.16.37.1-1436779756161-98585; csrftoken=9066683f393bef1948eb8d358f27a452', 'Cache-Control': 'max-age=259200', 'Upgrade-Insecure-Requests': '1'})
    Traceback (most recent call last):
      File "/opt/rh/python27/root/usr/lib64/python2.7/site-packages/tornado/web.py", line 1443, in _execute
        result = method(*self.path_args, **self.path_kwargs)
      File "/opt/rh/python27/root/usr/lib64/python2.7/site-packages/tornado/web.py", line 2800, in wrapper
        return method(self, *args, **kwargs)
      File "/opt/rh/python27/root/usr/lib/python2.7/site-packages/notebook/tree/handlers.py", line 50, in get
        terminals_available=self.settings['terminals_available'],
      File "/opt/rh/python27/root/usr/lib/python2.7/site-packages/notebook/base/handlers.py", line 302, in render_template
        template = self.get_template(name)
      File "/opt/rh/python27/root/usr/lib/python2.7/site-packages/notebook/base/handlers.py", line 298, in get_template
        return self.settings['jinja2_env'].get_template(name)
      File "/opt/rh/python27/root/usr/lib/python2.7/site-packages/jinja2/environment.py", line 719, in get_template
        return self._load_template(name, self.make_globals(globals))
      File "/opt/rh/python27/root/usr/lib/python2.7/site-packages/jinja2/environment.py", line 693, in _load_template
        template = self.loader.load(self, name, globals)
      File "/opt/rh/python27/root/usr/lib/python2.7/site-packages/jinja2/loaders.py", line 127, in load
        code = environment.compile(source, name, filename)
      File "/opt/rh/python27/root/usr/lib/python2.7/site-packages/jinja2/environment.py", line 493, in compile
        self.handle_exception(exc_info, source_hint=source)
      File "/opt/rh/python27/root/usr/lib/python2.7/site-packages/notebook/templates/tree.html", line 8, in template
        data-base-url="{{base_url | urlencode}}"
    TemplateAssertionError: no filter named 'urlencode'
{% endhighlight %}

**Solution:** Update jinja2 python package using the following command:

{% highlight bash %}
source /opt/rh/python27/enable
pip install jinja2 --upgrade 
{% endhighlight %}
___

**Error:** Can't connect to Jupyter notebook via IP-Adress 127.0.0.1

**Solution:** Try to connect to the IP-adress of your virtual machine instead. To get the correct IP-adress, connect to the HDP virutal machine via ssh and use the command:

{% highlight bash %}
ifconfig
{% endhighlight %}

Take a note on the entry "inet addr: XXX.XXX.XXX.XXX" from the device eth0 and write your IP-adress down. Afterwards, you should be able to connect through typing XXX.XXX.XXX.XXX:8889 in your browser. (For me it was 172.16.37.1:8889)


[hdp download]: http://hortonworks.com/hdp/downloads/
[virtualbox download]: https://www.virtualbox.org/wiki/Downloads
[HDP Tutorials]: http://hortonworks.com/tutorials/
[old article]: http://simnotes.github.io/blog/installing-ipython-notebook-on-hdp-2.3/