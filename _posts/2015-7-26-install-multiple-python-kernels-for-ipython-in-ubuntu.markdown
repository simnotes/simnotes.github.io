---
layout: post
title:  "Install multiple python kernels for IPython in ubuntu"
date:   2015-7-26
published: true
---

<p class="intro"><span class="dropcap">H</span>ere is a quick one: Everytime I'm using python I struggle to select the correct version. Yes there is <a href="http://docs.python-guide.org/en/latest/dev/virtualenvs/">virtualenv</a>, but to me this seems unnerving and distractful. So here is a way to install both python-kernels for python2 and python3 in ipython notebook. This way, you can choose which python version to use with a simple click</p>

First you have to install both versions of python:

{% highlight bash %}
sudo apt-get install python python3
{% endhighlight %}


Then you may install IPython Notebook to python3 and install IPython for python2

{% highlight bash %}
sudo pip3 install "ipython[notebook]"
sudo pip2 install ipython
{% endhighlight %}


Last, you have to add both kernels to IPython Notebook:

{% highlight bash %}
sudo ipython kernelspec install-self
sudo ipython2 kernelspec install-self
{% endhighlight %}

You're done! Now you can start up IPython Notebook normally and everytime you create a new notebook, you may select the kernel to be used. Great!

{% highlight bash %}
ipython notebook
{% endhighlight %}