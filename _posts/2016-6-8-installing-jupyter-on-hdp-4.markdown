---
layout: post
title:  "Installing Jupyter (IPython Notebook) on HDP 2.4"
date:   2016-6-8
published: true
---

**Update:** I revised the [old article from January 2016][old article] to work with the currently available Hortonworks Dataplatform HDP 2.4 and Jupyter. Thanks to Carolyn Duby for mentioning the updated download location for pypa setup tools!

<p class="intro"><span class="dropcap">S</span>ince we're using the Hortonworks Data Plattform at work, I toyed around with the HDP 2.4 Sandbox to see whats inside. One thing I've found is, they upgraded the Apache Spark Version from 1.5 to the more recently 1.6 release. Needless to say, it sparked my interest... (you see, what I did there?)</p>

Being more comfortable with the Python language than Scala, I decided to fire up the included pyspark shell, but found it not to be that engaging. I always liked the REPL interface from Python, the direct way of programming, but it laked the sustainability of "normal" written scripts. So to get a better grip on how everything works, I decided to upgrade the distribution and go ahead to install Jupyter, which lets me program like on a shell, but has the longevity of written code. I reaaaaally like that interface :)

So here is a step by step manual, of how to get Jupyter running on HDP 2.4 Sandbox:

### Step 01: Download and Install HDP
- Download the Sandbox [here][hdp download]
- Download Virtualbox [here][virtualbox download]
- After installing Virtualbox and importing the virtual machine into it, you have to add a new portforwarding rule. To do this, you have to right click on the imported VM, go to settings/network settings, extended and click on port-forwarding. Add the following rule: ipython notebook, 127.0.0.1, Port 8889, Port 8889
- After that, you may boot the VM

### Step 02: Connect via ssh and install needed libraries
- You may connect via ssh: root@127.0.0.1:2222 / password: hadoop
- install needed libraries: 

{% highlight bash %}
yum install nano centos-release-scl zlib-devel \
bzip2-devel openssl-devel ncurses-devel \
sqlite-devel readline-devel tk-devel \
gdbm-devel db4-devel libpcap-devel xz-devel \
libpng-devel libjpg-devel atlas-devel
{% endhighlight %}

{% highlight bash %}
yum groupinstall "Development tools"
{% endhighlight %}

### Step 03: Install Python 2.7
Since HDP 2.4 Sandbox only comes with Python 2.6 installed, but Jupyter requires at least python 2.7, we have to install it manually. To do without recompiling it ourselves, we can use the CentOS Software Collections Repository, which we installed in the previews step (centos-release-SCL). So just type
{% highlight bash %}
yum install python27
{% endhighlight %}

to get python 2.7. 

Now we have to activate it for this session:
{% highlight bash %}
source /opt/rh/python27/enable
{% endhighlight %}

### Step 04: Install pip for Python 2.7
To get Jupyter and some more python libraries, we will use pip - the python package manager. So let's install pip and upgrade pip to the latest version:
{% highlight bash %}
wget https://bootstrap.pypa.io/ez_setup.py -O - | python
easy_install-2.7 pip
pip install --upgrade pip
{% endhighlight %}


### Step 05: Install Jupyter (IPython Notebook)
First, we will install some more "standard" python libraries for data scientist to have something to toy around with. Afterwards, we will install Jupyter (IPython Notebook). This might take a while.

{% highlight bash %}
pip install --upgrade numpy scipy \
pandas scikit-learn tornado pyzmq \
pygments matplotlib jinja2 jsonschema

pip install jupyter
{% endhighlight %}


### Step 06: Create Jupyter startup script
Create a new file in your home directory

{% highlight bash %}
nano ~/start_jupyter.sh
{% endhighlight %}

and add the following content to it.
{% highlight bash %}
#!/bin/bash
source /opt/rh/python27/enable
IPYTHON_OPTS="notebook --port 8889 \
--notebook-dir='/usr/hdp/current/spark-client/' \
--ip='*' --no-browser" pyspark
{% endhighlight %}

Afterwards make this script executable
{% highlight bash %}
chmod +x ~/start_jupyter.sh
{% endhighlight %}

### Step 07: Start IPython Notebook
You're done! You may start Jupyter from your home directory with the command

{% highlight bash %}
./start_jupyter.sh
{% endhighlight %}

After that you may open your webbrowser and open http://127.0.0.1:8889 to get to the Jupyter startpage or http://127.0.0.1:4040 to open Spark UI, which gets you some insight into memory consumption and duration of our Apache Spark jobs.

Cheers!

___

### Troubleshooting guide

**Error:** Can't connect to Jupyter notebook via IP-Adress 127.0.0.1

**Solution:** Try to connect to the IP-adress of your virtual machine instead. To get the correct IP-adress, connect to the HDP virutal machine via ssh and use the command:

{% highlight bash %}
ifconfig
{% endhighlight %}

Take a note on the entry "inet addr: XXX.XXX.XXX.XXX" from the device eth0 and write your IP-adress down. Afterwards, you should be able to connect through typing XXX.XXX.XXX.XXX:8889 in your browser. (For me it was 172.16.37.1:8889)


[hdp download]: http://hortonworks.com/downloads/
[virtualbox download]: https://www.virtualbox.org/wiki/Downloads
[HDP Tutorials]: http://hortonworks.com/tutorials/
[old article]: http://simnotes.github.io/blog/installing-jupyter-on-hdp-2.3.2/