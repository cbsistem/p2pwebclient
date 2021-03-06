/*
 * Copyright (c) 2001-2003 Regents of the University of California.
 * All rights reserved.
 *
 * See the file LICENSE included in this distribution for details.
 */

package bamboo.softscribe;
import java.math.BigInteger;
import java.util.Iterator;
import java.util.LinkedList;
import ostore.util.AssertionViolatedException;
import ostore.util.CountBuffer;
import ostore.util.InputBuffer;
import ostore.util.NodeId;
import ostore.util.OutputBuffer;
import ostore.util.QSException;
import ostore.util.QuickSerializable;
import bamboo.util.GuidTools;
import ostore.network.NetworkMessage;
import seda.sandStorm.api.QueueElementIF;

/**
 * MCastUpMsg
 *
 * A message to be sent to the specified multicast group. This gets
 *  routed via Bamboo to the group's root. Thus an object of this class
 *  is a Bamboo payload.
 *
 * @author  David Oppenheimer
 * @version $Id: MCastUpMsg.java,v 1.3 2004/08/04 19:23:27 srhea Exp $ */
public class MCastUpMsg implements QuickSerializable, QueueElementIF {

    public NodeId srcid;
    public BigInteger dstguid; //identifies group to which o should be multicast
    public QuickSerializable o;

    public MCastUpMsg (NodeId srcid, BigInteger dstguid, QuickSerializable o) {
	this.srcid = srcid;
	this.dstguid = dstguid;
	this.o = o;
    }

    public MCastUpMsg (MCastUpMsg other) {
	srcid = other.srcid;
	dstguid = other.dstguid;
	o = other.o;
    }

    public MCastUpMsg (InputBuffer buffer) throws QSException {
	srcid = (NodeId)buffer.nextObject ();
	dstguid = buffer.nextBigInteger ();
	o = buffer.nextObject ();
    }

    public void serialize (OutputBuffer buffer) {
	buffer.add (srcid);
	buffer.add (dstguid);
	buffer.add (o);
    }

    public String toString () {
	return "(MCastUpMsg  srcid=" + srcid + 
	    " dstguid=" + GuidTools.guid_to_string (dstguid) + 
	    " o=" + o +
	    ")";
    }
}

