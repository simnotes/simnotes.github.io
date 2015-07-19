---
layout: post
title:  "Installing IPython Notebook on HDP 2.3"
date:   2015-7-18
published: true
---

<p class="intro"><span class="dropcap">S</span>ince we're using the Hortonworks Data Plattform at work, I toyed around with the HDP 2.3 Preview Sandbox to see whats inside. One thing I've found is, they upgraded the Apache Spark Version from 1.2 to the more recently 1.3.1 release. Needless to say, it sparked my interest... (you see, what I did there?)</p>

Being more comfortable with the Python language than Scala, I decided to fire up the included pyspark shell, but found it not to be that engaging. I always liked the REPL interface from Python, the direct way of programming, but it laked the sustainability of "normal" written scripts. So to get a better grip on how everything works, I decided to upgrade the distribution and go ahead to install IPython notebook, which lets me program like on a shell, but has the longevity of written code. I reaaaaally like that interface :)

So here is a step by step manual, of how to get IPython Notebook running on HDP 2.3 Preview Sandbox:

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
Since HDP 2.3 Preview Sandbox only comes with Python 2.6 installed, but IPython Notebook requires at least python 2.7, we have to install it manually. To do without recompiling it ourselves, we can use the CentOS Software Collections Repository, which we installed in the previews step (centos-release-SCL). So just type
{% highlight bash %}
yum install python27
{% endhighlight %}

to get python 2.7. 

Now we have to activate it for this session:
{% highlight bash %}
source /opt/rh/python27/enable
{% endhighlight %}

### Step 04: Install pip for Python 2.7
To get IPython Notebook and some more python libraries, we will use pip - the python package manager. So let's install pip:
{% highlight bash %}
wget https://bitbucket.org/pypa/setuptools\
/raw/bootstrap/ez_setup.py

python ez_setup.py
easy_install-2.7 pip
{% endhighlight %}


### Step 05: Install IPython Notebook
First, we will install some more "standard" python libraries for data scientist to have something to toy around with. Afterwards, we will install IPython Notebook.

{% highlight bash %}
pip install numpy scipy pandas \
scikit-learn tornado pyzmq \
pygments matplotlib jinja2 jsonschema

pip install "ipython[notebook]"
{% endhighlight %}


### Step 06: Configure IPython Notebook
To get IPython Notebook running, we first have to create a new profile:

{% highlight bash %}
ipython profile create pyspark
{% endhighlight %}

and change some values in the file 
(don't forget to remove the #-Symbol in front of the lines!)

{% highlight bash %}
nano ~/.ipython/profile_pyspark/ipython_notebook_config.py
{% endhighlight %}

new values: 

- c.NotebookApp.ip = '*'
- c.NotebookApp.open_browser = False
- c.NotebookApp.port = 8889
- c.NotebookApp.notebook_dir = u'/usr/hdp/2.3.0.0-2130/spark/'

You may also use this <a href="{{ '/assets/files/config_spark.sh' | prepend: site.baseurl }}">script</a> to to the changes for you.

### Step 07: Create startup script
Create a new file in your home directory

{% highlight bash %}
nano ~/start_ipython_notebook.sh
{% endhighlight %}

and add the following content to it.
{% highlight bash %}
#!/bin/bash
source /opt/rh/python27/enable
IPYTHON_OPTS="notebook --profile pyspark" pyspark
{% endhighlight %}

Afterwars make this script executable
{% highlight bash %}
chmod +x start_ipython_notebook.sh
{% endhighlight %}

### Step 08: Start IPython Notebook
You're done! You may start IPython Notebook from your home directory with the command

{% highlight bash %}
./start_ipython_notebook.sh
{% endhighlight %}

After that you may open your webbrowser and open http://127.0.0.1:8889 to get to the IPython Notebook startpage or http://127.0.0.1:4040 to open Spark UI, which gets you some insight into memory consumption and duration of our Apache Spark jobs.

Cheers!


[hdp download]: http://hortonworks.com/hdp/downloads/
[virtualbox download]: https://www.virtualbox.org/wiki/Downloads
[HDP Tutorials]: http://hortonworks.com/tutorials/