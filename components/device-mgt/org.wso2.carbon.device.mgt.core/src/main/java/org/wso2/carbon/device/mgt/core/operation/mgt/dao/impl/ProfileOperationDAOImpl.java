/*
 *   Copyright (c) 2015, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *   WSO2 Inc. licenses this file to you under the Apache License,
 *   Version 2.0 (the "License"); you may not use this file except
 *   in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing,
 *   software distributed under the License is distributed on an
 *   "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *   KIND, either express or implied.  See the License for the
 *   specific language governing permissions and limitations
 *   under the License.
 *
 */
package org.wso2.carbon.device.mgt.core.operation.mgt.dao.impl;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.wso2.carbon.device.mgt.common.DeviceIdentifier;
import org.wso2.carbon.device.mgt.common.operation.mgt.Operation;
import org.wso2.carbon.device.mgt.core.operation.mgt.ProfileOperation;
import org.wso2.carbon.device.mgt.core.operation.mgt.dao.OperationManagementDAOException;
import org.wso2.carbon.device.mgt.core.operation.mgt.dao.OperationManagementDAOFactory;
import org.wso2.carbon.device.mgt.core.operation.mgt.dao.OperationManagementDAOUtil;

import java.io.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class ProfileOperationDAOImpl extends OperationDAOImpl {

    private static final Log log = LogFactory.getLog(ProfileOperationDAOImpl.class);

    public int addOperation(Operation operation) throws OperationManagementDAOException {
        int operationId = super.addOperation(operation);
        ProfileOperation profileOp = (ProfileOperation) operation;
        Connection conn = OperationManagementDAOFactory.getConnection();

        PreparedStatement stmt = null;
        ResultSet rs = null;
        ByteArrayOutputStream bao = null;
        ObjectOutputStream oos = null;
        try {
            bao = new ByteArrayOutputStream();
            oos = new ObjectOutputStream(bao);
            oos.writeObject(profileOp);

            stmt = conn.prepareStatement("INSERT INTO DM_PROFILE_OPERATION(OPERATION_ID, PAYLOAD) VALUES(?, ?)");
            stmt.setInt(1, operationId);
            stmt.setBytes(2, bao.toByteArray());
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new OperationManagementDAOException("Error occurred while adding profile operation", e);
        } catch (IOException e) {
            throw new OperationManagementDAOException("Error occurred while serializing profile operation object", e);
        } finally {
            if (bao != null) {
                try {
                    bao.close();
                } catch (IOException e) {
                    log.warn("Error occurred while closing ByteArrayOutputStream", e);
                }
            }
            if (oos != null) {
                try {
                    oos.close();
                } catch (IOException e) {
                    log.warn("Error occurred while closing ObjectOutputStream", e);
                }
            }
            OperationManagementDAOUtil.cleanupResources(stmt, rs);
        }
        return operationId;
    }

    @Override
    public int updateOperation(Operation operation) throws OperationManagementDAOException {
        return 0;
    }

    @Override
    public int deleteOperation(int id) throws OperationManagementDAOException {
        return 0;
    }

    @Override
    public Operation getOperation(int operationId) throws OperationManagementDAOException {
        Connection conn = OperationManagementDAOFactory.getConnection();

        PreparedStatement stmt = null;
        ResultSet rs = null;
        ByteArrayInputStream bais = null;
        ObjectInputStream ois = null;
        try {
            stmt = conn.prepareStatement("SELECT PAYLOAD FROM DM_PROFILE_OPERATION WHERE ID = ?");
            stmt.setInt(1, operationId);
            rs = stmt.executeQuery();

            byte[] payload = new byte[0];
            if (rs.next()) {
                payload = rs.getBytes("PAYLOAD");
            }

            bais = new ByteArrayInputStream(payload);
            ois = new ObjectInputStream(bais);
            return (ProfileOperation) ois.readObject();
        } catch (SQLException e) {
            throw new OperationManagementDAOException("Error occurred while adding profile operation", e);
        } catch (IOException e) {
            throw new OperationManagementDAOException("Error occurred while serializing profile operation object", e);
        } catch (ClassNotFoundException e) {
            throw new OperationManagementDAOException("Error occurred while casting retrieved payload as a " +
                    "ProfileOperation object", e);
        } finally {
            if (bais != null) {
                try {
                    bais.close();
                } catch (IOException e) {
                    log.warn("Error occurred while closing ByteArrayOutputStream", e);
                }
            }
            if (ois != null) {
                try {
                    ois.close();
                } catch (IOException e) {
                    log.warn("Error occurred while closing ObjectOutputStream", e);
                }
            }
            OperationManagementDAOUtil.cleanupResources(stmt, rs);
        }
    }

    @Override
    public List<Operation> getOperations() throws OperationManagementDAOException {
        return null;
    }

    @Override
    public List<Operation> getOperations(String status) throws OperationManagementDAOException {
        return null;
    }

    @Override
    public Operation getNextOperation(DeviceIdentifier deviceId) throws OperationManagementDAOException {
        return null;
    }

}
