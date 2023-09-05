# Service version matrix

Services in {{brand}} are updated on a regular basis and on a rolling schedule.

This section lists the cloud API service versions available in each {{brand}} region.

* [Public Cloud](public.md): versions running in our {{company}} Public Cloud regions.

* [Compliant Cloud](compliant.md): versions running in our {{company}} Compliant Cloud regions.


## OpenStack Services

[OpenStack releases](https://releases.openstack.org) are named in alphabetical order, and occur on a six-month release schedule.
In {{company}} Public Cloud we upgrade OpenStack releases annually; this means that we normally deploy every other OpenStack release and skip the intervening one.

{{brand}} currently runs OpenStack [Xena](https://releases.openstack.org/xena) and [Antelope](https://releases.openstack.org/antelope).
The fact that {{brand}} has skipped the [Zed](https://releases.openstack.org/zed) release (in addition to [Yoga](https://releases.openstack.org/antelope), as we normally would have) is due to a one-time upstream release policy change.
We return to the prior deployment schedule after the Antelope upgrade, and expect the next deployed release to be [Caracal](https://releases.openstack.org/caracal).


## Ceph Services

[Ceph major releases](https://docs.ceph.com/en/latest/releases/index.html#release-timeline) are also named in alphabetical order, and occur on a roughly annual schedule.

{{brand}} currently runs Ceph [Quincy](https://docs.ceph.com/en/latest/releases/quincy).
