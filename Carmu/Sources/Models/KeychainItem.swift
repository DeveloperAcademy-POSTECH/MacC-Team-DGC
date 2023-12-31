//
//  KeychainItem.swift
//  Carmu
//
//  Created by 김영빈 on 2023/10/04.
//

import Foundation

import FirebaseDatabase
/*
 Keychain에 저장되는 데이터를 관리하기 위한 구조체
 */
struct KeychainItem {

    // MARK: 오류 타입

    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unexpectedItemData
        case unhandledError
    }

    // MARK: - 프로퍼티

    let service: String

    private(set) var account: String

    let accessCrew: String?

    // MARK: - 이니셜라이저

    init(service: String, account: String, accessCrew: String? = nil) {
        self.service = service
        self.account = account
        self.accessCrew = accessCrew
    }

    // MARK: Keychain 접근 메소드

    /*
     키체인 item 조회
     */
    func readItem() throws -> String {
        /*
         service, account, accessCrew와 매치되는 키체인 item을 찾기 위한 쿼리를 생성해줍니다.
         */
        var query = KeychainItem.keychainQuery(withService: service, account: account, accessCrew: accessCrew)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue

        // 쿼리의 내용과 일치하는 키체인 item이 있다면 추출합니다.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        // 결과 처리
        guard status != errSecItemNotFound else {
            throw KeychainError.noPassword
        }
        guard status == noErr else {
            throw KeychainError.unhandledError
        }

        // 쿼리 결과로 얻어낸 password(키체인 item)에서 원하는 값을 파싱합니다.
        guard let existingItem = queryResult as? [String: AnyObject],
              let passwordData = existingItem[kSecValueData as String] as? Data,
              let password = String(data: passwordData, encoding: String.Encoding.utf8)
        else {
            throw KeychainError.unexpectedPasswordData
        }

        return password
    }

    /*
     키체인 item 새로추가 or 업데이트
     */
    func saveItem(_ password: String) throws {
        // password를 Data 객체로 인코딩
        let encodedPassword = password.data(using: String.Encoding.utf8)!

        do {
            // 동일한 item이 키체인에 존재하는지 체크
            try _ = readItem()

            // 기존의 item을 새로운 password로 업데이트
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedPassword as AnyObject?

            let query = KeychainItem.keychainQuery(withService: service, account: account, accessCrew: accessCrew)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)

            // 에러 처리
            guard status == noErr else { throw KeychainError.unhandledError }
        } catch KeychainError.noPassword {
            /*
             키체인에 해당 password 데이터가 없다는 것이 확인되면,
             새로운 Keychain item으로 저장할 딕셔너리를 만들어준다
             */
            var newItem = KeychainItem.keychainQuery(withService: service, account: account, accessCrew: accessCrew)
            newItem[kSecValueData as String] = encodedPassword as AnyObject?

            // 키체인에 새로운 item을 저장
            let status = SecItemAdd(newItem as CFDictionary, nil)

            // 에러 처리
            guard status == noErr else { throw KeychainError.unhandledError }
        }
        // 키체인 값이 변경되면 User.databasePAthWithUID도 갱신해준다.
        guard let uid = KeychainItem.currentUserIdentifier else {
            return
        }
        User.databasePathWithUID = Database.database().reference().child("users/\(uid)")
    }

    /*
     키체인 item 삭제
     */
    func deleteItem() throws {
        // 키체인에서 item 삭제
        let query = KeychainItem.keychainQuery(withService: service, account: account, accessCrew: accessCrew)
        let status = SecItemDelete(query as CFDictionary)

        // 에러 처리
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError }
    }

    // MARK: - 기타 Convenience

    /*
     키체인 쿼리 생성 메소드
     */
    private static func keychainQuery(
        withService service: String,
        account: String? = nil,
        accessCrew: String? = nil
    ) -> [String: AnyObject] {
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?

        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }

        if let accessCrew = accessCrew {
            query[kSecAttrAccessGroup as String] = accessCrew as AnyObject?
        }

        return query
    }

    // 현재 유저의 identifier
    /*
     You should store the user identifier in your account management system.
     */
    static var currentUserIdentifier: String? {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            return nil
        }
        do {
            let storedIdentifier = try KeychainItem(
                service: bundleIdentifier,
                account: "userIdentifier"
            ).readItem()
            return storedIdentifier
        } catch {
            return nil
        }
    }

    // 현재 유저의 DeviceToken
    static var currentUserDeviceToken: String? {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            return nil
        }
        do {
            let storedDeviceToken = try KeychainItem(
                service: bundleIdentifier,
                account: "FCMToken"
            ).readItem()
            return storedDeviceToken
        } catch {
            return nil
        }
    }

    // MARK: - 키체인 데이터를 삭제하는 메서드
    /*
     account 종류
     - userIdentifier: 유저의 uid
     - FCMToken: 서버 푸쉬에 필요한 디바이스 토큰
     */
    static func deleteUserDataFromKeychain(account: String) {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            return
        }
        do {
            try KeychainItem(
                service: bundleIdentifier,
                account: account
            ).deleteItem()
            print("키체인에서 \(account) 삭제 성공!!!")
        } catch {
            print("키체인으로부터 \(account)를 삭제하지 못했습니다.")
        }
    }
}
