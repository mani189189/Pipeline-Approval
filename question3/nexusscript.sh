#!bin/bash
server="http://example.com/nexus/content/repositories"
repo="snapshots"
name="com.exmple.server"
artifact="com/example/$name"
path=$server/$repo/$artifact
mvnMetadata=$(curl -s "$path/maven-metadata.xml")
echo "Metadata: $mvnMetadata"
jar=""
version=$( echo "$mvnMetadata" | xpath -e "//versioning/release/text()" 2> /dev/null)
if [[ $version = *[!\ ]* ]]; then
  jar=$name-$version.jar
else
  version=$(echo "$mvnMetadata" | xpath -e "//versioning/versions/version[last()]/text()")
  snapshotMetadata=$(curl -s "$path/$version/maven-metadata.xml")
  timestamp=$(echo "$snapshotMetadata" | xpath -e "//snapshot/timestamp/text()")
  buildNumber=$(echo "$snapshotMetadata" | xpath -e "//snapshot/buildNumber/text()")
  snapshotVersion=$(echo "$version" | sed 's/\(-SNAPSHOT\)*$//g')
  jar=$name-$snapshotVersion-$timestamp-$buildNumber.jar
fi
jarUrl=$path/$version/$jar
echo $jarUrl
mkdir -p /opt/server/
wget -O /opt/server/server.jar -q -N $jarUrl
