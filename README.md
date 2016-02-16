### Getting Started 

[![Join the chat at https://gitter.im/asi-catarsi/lai](https://badges.gitter.im/asi-catarsi/lai.svg)](https://gitter.im/asi-catarsi/lai?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

To run this application, you will need a Developer Cloud Sandbox that can be requested from [Terradue's Portal](http://www.terradue.com/partners), provided user registration approval. 

### Installation 

Log on the developer sandbox and run these commands in a shell:

```bash
cd
git clone git@github.com:asi-catarsi/lai.git
cd lai
mvn install
```

### Submitting the workflow

Run this command in a shell:

```bash
ciop-simwf
```

Or invoke the Web Processing Service via the Sandbox dashboard providing a start/stop date in the format YYYY/MM/DD (e.g. 2012-04-01 and 2012-04-03) and a bounding box (e.g -180,90,180,-90).
