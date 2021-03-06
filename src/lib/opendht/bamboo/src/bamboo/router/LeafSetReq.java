/*
 * Copyright (c) 2001-2003 Regents of the University of California.
 * All rights reserved.
 *
 * See the file LICENSE included in this distribution for details.
 */

package bamboo.router;
import ostore.network.NetworkMessage;
import ostore.util.InputBuffer;
import ostore.util.NodeId;
import ostore.util.OutputBuffer;
import ostore.util.QSException;

/**
 * Will result in a LeafSetChanged message being sent back to the sender.
 * 
 * @author Sean C. Rhea
 * @version $Id: LeafSetReq.java,v 1.7 2003/10/05 18:22:11 srhea Exp $
 */
public class LeafSetReq extends NetworkMessage {

    public LeafSetReq (NodeId dest) {
	super (dest, false);
    }

    public LeafSetReq (InputBuffer buffer) throws QSException {
	super (buffer);
    }

    public void serialize (OutputBuffer buffer) {
	super.serialize (buffer);
    }

    public Object clone () throws CloneNotSupportedException {
	return super.clone ();
    }

    public String toString () {
	return "(LeafSetReq super=" + super.toString () + ")";
    }
}

